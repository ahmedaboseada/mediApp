import HealthMeasurement from '../../models/health-measurement.model.js';
import SymptomLog from '../../models/symptom-log.model.js';
import { patientModel } from '../../models/index.js';

export const addMeasurement = async (req, res, next) => {
    const { id: userId } = req.user;

    const patient = await patientModel.findOne({ userId });
    if (!patient) return res.status(404).json({ message: 'Patient not found' });

    const measurementData = { ...req.body, patientId: patient._id };

    // basic validation depending on type
    if (measurementData.type === 'blood_pressure') {
        if (!measurementData.systolic || !measurementData.diastolic) {
            return res.status(400).json({ message: 'Systolic and diastolic values required for blood pressure' });
        }
    } else {
        if (!measurementData.value) {
            return res.status(400).json({ message: 'Value required for this measurement type' });
        }
    }

    const measurement = await HealthMeasurement.create(measurementData);
    res.status(201).json({ message: 'Measurement added successfully', measurement });
};

export const getMeasurements = async (req, res, next) => {
    const { id: userId } = req.user;
    const { type } = req.query;

    const patient = await patientModel.findOne({ userId });
    if (!patient) return res.status(404).json({ message: 'Patient not found' });

    let query = { patientId: patient._id };
    if (type) query.type = type;

    const measurements = await HealthMeasurement.find(query).sort({ date: 1 });
    res.status(200).json({ message: 'Success', measurements });
};

export const addSymptom = async (req, res, next) => {
    const { id: userId } = req.user;

    const patient = await patientModel.findOne({ userId });
    if (!patient) return res.status(404).json({ message: 'Patient not found' });

    const symptomData = { ...req.body, patientId: patient._id };
    const symptom = await SymptomLog.create(symptomData);

    res.status(201).json({ message: 'Symptom logged successfully', symptom });
};

export const getSymptoms = async (req, res, next) => {
    const { id: userId } = req.user;

    const patient = await patientModel.findOne({ userId });
    if (!patient) return res.status(404).json({ message: 'Patient not found' });

    const symptoms = await SymptomLog.find({ patientId: patient._id }).sort({ date: -1 });
    res.status(200).json({ message: 'Success', symptoms });
};
