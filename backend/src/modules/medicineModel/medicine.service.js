import { medicineModel, patientModel } from '../../models/index.js';
import { medicineFrequency, medicineStatus, weekDays } from '../../config/CONSTANTS.js';
import { GoogleGenerativeAI } from '@google/generative-ai';

const enhanceMedicineWithAI = async (medicineId, medicineName) => {
    if (!medicineName || !process.env.GEMINI_API_KEY) return;
    try {
        const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
        const model = genAI.getGenerativeModel({ model: "gemini-3-flash-preview", generationConfig: { responseMimeType: "application/json" } });

        const prompt = `You are a strict medical pharmacist AI assistant.
Analyze the following medication brand name or description: "${medicineName}".
Identify its actual pharmaceutical active chemical ingredient(s). Do not just repeat the brand name.
For example, if the input is "Panadol" or "Tylenol", the activeIngredient is "Paracetamol" or "Acetaminophen". If input is "Dexazone", the activeIngredient is "Dexamethasone".
Respond with a single JSON object containing:
- "activeIngredient": string (only the chemical active ingredient name)
- "sideEffects": array of strings (top 3 common possible side effects)`;

        const result = await model.generateContent(prompt);
        const aiData = JSON.parse(result.response.text());
        
        const updates = {};
        if (aiData.activeIngredient) updates.activeIngredient = aiData.activeIngredient;
        if (Array.isArray(aiData.sideEffects) && aiData.sideEffects.length > 0) updates.sideEffects = aiData.sideEffects.slice(0, 3);
        
        if (Object.keys(updates).length > 0) {
            await medicineModel.findByIdAndUpdate(medicineId, updates);
        }
    } catch (err) {
        console.error("Failed to generate active ingredient with Gemini in BG:", err.message);
    }
};

export const addMedicine = async (req, res, next) => {
    const { id: userId } = req.user;

    const patient = await patientModel.findOne({ userId });
    if (!patient) return res.status(404).json({ message: 'Patient not found' });

    const medicineData = { 
        ...req.body, 
        patientId: patient._id, 
        activeIngredient: req.body.name, 
        sideEffects: req.body.sideEffects || [] 
    };

    const medicine = await medicineModel.create(medicineData);

    // Associate with patient
    patient.medications.push(medicine._id);
    await patient.save();
    
    // Background AI Task
    enhanceMedicineWithAI(medicine._id, req.body.name).catch(console.error);

    res.status(201).json({ message: 'Medicine added successfully', medicine });
};

export const getMedicines = async (req, res, next) => {
    const { id: userId } = req.user;
    const { filter } = req.query; // all, active, chronic

    const patient = await patientModel.findOne({ userId });
    if (!patient) return res.status(404).json({ message: 'Patient not found' });

    let query = { patientId: patient._id };

    if (filter === 'active') {
        query.$or = [
            { endDate: { $gte: new Date() } },
            { endDate: { $exists: false } },
            { endDate: null }
        ];
        // optionally filter by status: normal
        query.status = medicineStatus.normal;
    } else if (filter === 'chronic') {
        query.isChronic = true;
    }

    const medicines = await medicineModel.find(query).sort({ createdAt: -1 });

    res.status(200).json({ message: 'Success', medicines });
};

export const updateMedicine = async (req, res, next) => {
    const { id } = req.params;
    const { id: userId } = req.user;

    const patient = await patientModel.findOne({ userId });
    if (!patient) return res.status(404).json({ message: 'Patient not found' });

    const payload = { ...req.body };

    const medicine = await medicineModel.findOneAndUpdate(
        { _id: id, patientId: patient._id },
        payload,
        { new: true, runValidators: true }
    );

    if (!medicine) return res.status(404).json({ message: 'Medicine not found' });

    // Background AI Task if name provided
    if (req.body.name) {
        enhanceMedicineWithAI(medicine._id, req.body.name).catch(console.error);
    }

    res.status(200).json({ message: 'Medicine updated successfully', medicine });
};

export const deleteMedicine = async (req, res, next) => {
    const { id } = req.params;
    const { id: userId } = req.user;

    const patient = await patientModel.findOne({ userId });
    if (!patient) return res.status(404).json({ message: 'Patient not found' });

    const medicine = await medicineModel.findOneAndDelete({ _id: id, patientId: patient._id });
    if (!medicine) return res.status(404).json({ message: 'Medicine not found' });

    patient.medications.pull(medicine._id);
    await patient.save();

    res.status(200).json({ message: 'Medicine deleted successfully' });
};

export const getSchedule = async (req, res, next) => {
    const { id: userId } = req.user;
    const { date } = req.query; // Format: YYYY-MM-DD

    const patient = await patientModel.findOne({ userId });
    if (!patient) return res.status(404).json({ message: 'Patient not found' });

    const targetDate = date ? new Date(date) : new Date();
    targetDate.setHours(0, 0, 0, 0); // start of day

    const dayNames = Object.values(weekDays);
    const dayOfWeek = dayNames[targetDate.getDay()];

    const medicines = await medicineModel.find({ patientId: patient._id });

    const schedule = [];

    medicines.forEach(med => {
        // Skip if outside start-end date window
        if (med.startDate && targetDate < med.startDate) return;
        if (med.endDate && targetDate > med.endDate) return;

        let scheduledTimes = [];

        if (med.frequency === medicineFrequency.daily) {
            scheduledTimes = med.daily;
        } else if (med.frequency === medicineFrequency.weekly) {
            const block = med.weekly.find(b => b.day === dayOfWeek);
            if (block) scheduledTimes = block.times;
        } else if (med.frequency === medicineFrequency.specific) {
            const block = med.specific.find(b => new Date(b.day).getTime() === targetDate.getTime());
            if (block) scheduledTimes = block.times;
        }

        if (scheduledTimes.length > 0) {
            // Find status for this date from dates subdoc
            const dateLog = med.dates.find(d => new Date(d.date).getTime() === targetDate.getTime());

            const timesWithStatus = scheduledTimes.map(time => {
                const logsForTime = dateLog ? dateLog.times.find(t => t.time === time) : null;
                return {
                    time,
                    taken: logsForTime ? logsForTime.taken : false
                };
            });

            schedule.push({
                medicineId: med._id,
                name: med.activeIngredient || 'Unnamed Medicine',
                criticalMode: med.criticalMode,
                type: med.type,
                dosage: med.dosage,
                times: timesWithStatus
            });
        }
    });

    res.status(200).json({ message: 'Success', schedule });
};

export const markAsTaken = async (req, res, next) => {
    const { id } = req.params;
    const { date, time, taken } = req.body;
    const { id: userId } = req.user;

    const patient = await patientModel.findOne({ userId });
    if (!patient) return res.status(404).json({ message: 'Patient not found' });

    const medicine = await medicineModel.findOne({ _id: id, patientId: patient._id });
    if (!medicine) return res.status(404).json({ message: 'Medicine not found' });

    const targetDate = new Date(date);
    targetDate.setHours(0, 0, 0, 0);

    let dateLogIdx = medicine.dates.findIndex(d => new Date(d.date).getTime() === targetDate.getTime());

    let isStatusChangedToTaken = false;

    if (dateLogIdx > -1) {
        let timeLogIdx = medicine.dates[dateLogIdx].times.findIndex(t => t.time === time);
        if (timeLogIdx > -1) {
            if (!medicine.dates[dateLogIdx].times[timeLogIdx].taken && taken) {
                isStatusChangedToTaken = true;
            }
            medicine.dates[dateLogIdx].times[timeLogIdx].taken = taken;
        } else {
            medicine.dates[dateLogIdx].times.push({ time, taken });
            if (taken) isStatusChangedToTaken = true;
        }
    } else {
        medicine.dates.push({
            date: targetDate,
            times: [{ time, taken }]
        });
        if (taken) isStatusChangedToTaken = true;
    }

    let restockAlert = false;

    // Decrease stock if changed to taken
    if (isStatusChangedToTaken && medicine.stock > 0) {
        medicine.stock -= 1;

        if (medicine.stock <= medicine.leftThreshold) {
            restockAlert = true;
        }
    }

    if (!medicine.name) {
        medicine.name = medicine.activeIngredient || "Legacy Medicine";
    }

    await medicine.save();

    res.status(200).json({
        message: 'Status updated successfully',
        restockAlert,
        currentStock: medicine.stock
    });
};

export const addLog = async (req, res, next) => {
    const { id } = req.params;
    const { text, level } = req.body;
    const { id: userId } = req.user;

    const patient = await patientModel.findOne({ userId });
    if (!patient) return res.status(404).json({ message: 'Patient not found' });

    const medicine = await medicineModel.findOne({ _id: id, patientId: patient._id });
    if (!medicine) return res.status(404).json({ message: 'Medicine not found' });

    medicine.dailyFeedback.push({ text, level });

    if (!medicine.name) {
        medicine.name = medicine.activeIngredient || "Legacy Medicine";
    }

    await medicine.save();

    res.status(201).json({ message: 'Log added successfully', log: medicine.dailyFeedback[medicine.dailyFeedback.length - 1] });
};
