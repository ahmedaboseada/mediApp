import { medicineModel, patientModel, doctorModel, bookingModel, auditLogModel } from '../../models/index.js';
import { medicineFrequency, medicineStatus, weekDays } from '../../config/CONSTANTS.js';
import { GoogleGenerativeAI } from '@google/generative-ai';

const getContext = async (req) => {
    const { id: userId } = req.user;
    let patient;
    let docId = null;
    let activeBookingId = null;

    const patientLookup = await patientModel.findOne({ userId });
    if (patientLookup) {
        patient = patientLookup;
    } else {
        const docLookup = await doctorModel.findOne({ userId });
        if (docLookup) {
            const patientIdFromReq = req.body.patientId || req.query.patientId;
            if (!patientIdFromReq) {
                const err = new Error('Patient ID is required for doctor access');
                err.status = 400; throw err;
            }
            patient = await patientModel.findById(patientIdFromReq);
            docId = docLookup._id;

            const activeSession = await bookingModel.findOne({
                doctorId: docLookup._id,
                patientId: patient?._id,
                sessionActive: true,
                sessionExpiresAt: { $gt: new Date() }
            });

            if (!activeSession) {
                const err = new Error('You do not have an active editing session with this patient');
                err.status = 403; throw err;
            }
            activeBookingId = activeSession._id;
        }
    }
    
    if (!patient) {
        const err = new Error('Patient not found');
        err.status = 404; throw err;
    }
    return { patient, docId, activeBookingId };
};

const enhanceMedicineWithAI = async (medicineId, medicineName, submittedType) => {
    if (!medicineName || !process.env.GEMINI_API_KEY) return;
    try {
        const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
        const model = genAI.getGenerativeModel({ model: "gemini-2.5-flash", generationConfig: { responseMimeType: "application/json" } });

        const prompt = `You are a strict medical pharmacist AI assistant.
Analyze the following medication brand name or description: "${medicineName}". The user submitted its form/type as "${submittedType}".
Identify its actual pharmaceutical active chemical ingredient(s). Do not just repeat the brand name.
For example, if the input is "Panadol" or "Tylenol", the activeIngredient is "Paracetamol" or "Acetaminophen". If input is "Dexazone", the activeIngredient is "Dexamethasone".
Also determine if this medication is typically prescribed as a long-term "chronic" medication (e.g. for diabetes, hypertension, asthma).
Finally, verify or correct the medication type. The ONLY valid types are: 'tablet', 'capsule', 'syrup', 'injection', 'drops', 'spray', 'cream', 'other'. If the true form of "${medicineName}" does not match "${submittedType}", output the corrected valid type. Otherwise, output the submitted type.

Respond with a single JSON object containing:
- "activeIngredient": string (only the chemical active ingredient name)
- "sideEffects": array of strings (top 3 common possible side effects)
- "isChronicAI": boolean (true if it's typically a chronic/long-term medication, else false)
- "chronicCondition": string or null (if isChronicAI is true, the name of the common chronic condition it treats, e.g. "Hypertension". Otherwise null.)
- "correctedType": string (must be one of the exact valid types listed above)`;

        const result = await model.generateContent(prompt);
        const aiData = JSON.parse(result.response.text());

        const updates = {};
        if (aiData.activeIngredient) updates.activeIngredient = aiData.activeIngredient;
        if (Array.isArray(aiData.sideEffects) && aiData.sideEffects.length > 0) updates.sideEffects = aiData.sideEffects.slice(0, 3);

        if (aiData.isChronicAI) {
            updates.isChronic = true;
            updates.criticalMode = true;
            updates.status = 'critical';
        }

        if (aiData.correctedType && aiData.correctedType !== submittedType) {
            const validTypes = ['tablet', 'capsule', 'syrup', 'injection', 'drops', 'spray', 'cream', 'other'];
            if (validTypes.includes(aiData.correctedType)) {
                updates.type = aiData.correctedType;
            }
        }

        if (Object.keys(updates).length > 0) {
            await medicineModel.findByIdAndUpdate(medicineId, updates);
        }

        // Update Patient Models
        const medicine = await medicineModel.findById(medicineId);
        if (medicine) {
            const patient = await patientModel.findById(medicine.patientId);
            if (patient) {
                let patientUpdated = false;

                if (aiData.activeIngredient) {
                    if (!patient.activeIngredients) patient.activeIngredients = [];
                    const normalized = aiData.activeIngredient.toLowerCase().trim();
                    if (!patient.activeIngredients.some(ing => ing.toLowerCase().trim() === normalized)) {
                        patient.activeIngredients.push(aiData.activeIngredient.trim());
                        patientUpdated = true;
                    }
                }

                if (medicine.isChronic) {
                    if (!patient.longTermMedication) patient.longTermMedication = [];
                    if (!patient.longTermMedication.includes(medicineId)) {
                        patient.longTermMedication.push(medicineId);
                        patientUpdated = true;
                    }

                    if (aiData.chronicCondition) {
                        if (!patient.chronicConditions) patient.chronicConditions = [];
                        const normalizedCond = aiData.chronicCondition.toLowerCase().trim();
                        if (!patient.chronicConditions.some(cond => cond.toLowerCase().trim() === normalizedCond)) {
                            patient.chronicConditions.push(aiData.chronicCondition.trim());
                            patientUpdated = true;
                        }
                    }
                }

                if (patientUpdated) {
                    await patient.save();
                }
            }
        }
    } catch (err) {
        console.error("Failed to generate active ingredient with Gemini in BG:", err.message);
    }
};

export const addMedicine = async (req, res, next) => {
    try {
        const { patient, docId, activeBookingId } = await getContext(req);

    const medicineData = {
        ...req.body,
        patientId: patient._id,
        activeIngredient: req.body.name,
        sideEffects: req.body.sideEffects || []
    };

    if (medicineData.isChronic === true || medicineData.criticalMode === true || medicineData.status === 'critical') {
        medicineData.isChronic = true;
        medicineData.criticalMode = true;
        medicineData.status = 'critical';
    }

    const medicine = await medicineModel.create(medicineData);

    // Associate with patient
    patient.medications.push(medicine._id);
    await patient.save();

    // Background AI Task (VPS)
    enhanceMedicineWithAI(medicine._id, req.body.name, req.body.type).catch(console.error);

    if (docId) {
        await auditLogModel.create({ patientId: patient._id, doctorId: docId, bookingId: activeBookingId, action: 'add_medicine', details: `Added ${medicine.name}` });
    }

    res.status(201).json({ message: 'Medicine added successfully', medicine });
    } catch(err) { res.status(err.status || 500).json({ message: err.message }); }
};

export const getMedicines = async (req, res, next) => {
    try {
        const { id: userId, role } = req.user;
        const { filter } = req.query; // all, active, chronic

        let patient;
        if (role === 'doctor' || !req.user.role && req.query.patientId) {
            const patientIdFromReq = req.query.patientId || req.body.patientId;
            if (!patientIdFromReq) return res.status(400).json({ message: 'Patient ID required' });
            patient = await patientModel.findById(patientIdFromReq);
            // Verify doctor is connected or has active session
            const doc = await doctorModel.findOne({ userId });
            const isConnected = doc.connectedPatients?.some(c => String(c.patientId) === String(patient._id) && c.status === 'approved');
            if (!isConnected) return res.status(403).json({ message: 'Not connected to this patient' });
        } else {
            patient = await patientModel.findOne({ userId });
        }

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
    } catch(err) { res.status(err.status || 500).json({ message: err.message }); }
};

export const updateMedicine = async (req, res, next) => {
    try {
        const { id } = req.params;
        const { patient, docId, activeBookingId } = await getContext(req);

    const payload = { ...req.body };

    if (payload.isChronic === true || payload.criticalMode === true || payload.status === 'critical') {
        payload.isChronic = true;
        payload.criticalMode = true;
        payload.status = 'critical';
    } else if (payload.isChronic === false || payload.criticalMode === false) {
        payload.isChronic = false;
        payload.criticalMode = false;
        if (payload.status === 'critical' || !payload.status) payload.status = 'normal';
    }

    const medicine = await medicineModel.findOneAndUpdate(
        { _id: id, patientId: patient._id },
        payload,
        { new: true, runValidators: true }
    );

    if (!medicine) return res.status(404).json({ message: 'Medicine not found' });

    // Background AI Task (VPS) if name or type provided
    if (req.body.name || req.body.type) {
        enhanceMedicineWithAI(medicine._id, req.body.name || medicine.name, req.body.type || medicine.type).catch(console.error);
    }

    if (docId) {
        await auditLogModel.create({ patientId: patient._id, doctorId: docId, bookingId: activeBookingId, action: 'modify_medicine', details: `Modified ${medicine.name}` });
    }

    res.status(200).json({ message: 'Medicine updated successfully', medicine });
    } catch(err) { res.status(err.status || 500).json({ message: err.message }); }
};

export const deleteMedicine = async (req, res, next) => {
    try {
        const { id } = req.params;
        const { patient, docId, activeBookingId } = await getContext(req);

    const medicine = await medicineModel.findOneAndDelete({ _id: id, patientId: patient._id });
    if (!medicine) return res.status(404).json({ message: 'Medicine not found' });

    patient.medications.pull(medicine._id);
    await patient.save();

    if (docId) {
        await auditLogModel.create({ patientId: patient._id, doctorId: docId, bookingId: activeBookingId, action: 'delete_medicine', details: `Deleted ${medicine.name || 'medicine'}` });
    }

    res.status(200).json({ message: 'Medicine deleted successfully' });
    } catch(err) { res.status(err.status || 500).json({ message: err.message }); }
};

export const getSchedule = async (req, res, next) => {
    try {
        const { id: userId, role } = req.user;
        const { date } = req.query; // Format: YYYY-MM-DD

        let patient;
        if (role === 'doctor' || !req.user.role && req.query.patientId) {
            const patientIdFromReq = req.query.patientId || req.body.patientId;
            if (!patientIdFromReq) return res.status(400).json({ message: 'Patient ID required' });
            patient = await patientModel.findById(patientIdFromReq);
            const doc = await doctorModel.findOne({ userId });
            const isConnected = doc.connectedPatients?.some(c => String(c.patientId) === String(patient._id) && c.status === 'approved');
            if (!isConnected) return res.status(403).json({ message: 'Not connected to this patient' });
        } else {
            patient = await patientModel.findOne({ userId });
        }

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
                name: med.name || 'Unnamed Medicine',
                criticalMode: med.criticalMode,
                type: med.type,
                dosage: med.dosage,
                times: timesWithStatus
            });
        }
    });

    res.status(200).json({ message: 'Success', schedule });
    } catch(err) { res.status(err.status || 500).json({ message: err.message }); }
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
    let isStatusChangedToUntaken = false;

    if (dateLogIdx > -1) {
        let timeLogIdx = medicine.dates[dateLogIdx].times.findIndex(t => t.time === time);
        if (timeLogIdx > -1) {
            if (!medicine.dates[dateLogIdx].times[timeLogIdx].taken && taken) {
                isStatusChangedToTaken = true;
            } else if (medicine.dates[dateLogIdx].times[timeLogIdx].taken && !taken) {
                isStatusChangedToUntaken = true;
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
    } else if (isStatusChangedToUntaken) {
        // Increase stock back if changed to untaken
        if (medicine.stock !== undefined && medicine.stock !== null) {
            medicine.stock += 1;
        }
        
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
