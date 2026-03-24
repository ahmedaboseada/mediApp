import joi from 'joi';

export const addMeasurementSchema = {
    body: joi.object({
        type: joi.string().valid('blood_pressure', 'blood_sugar', 'weight', 'heart_rate').required(),
        value: joi.number().optional(),
        systolic: joi.number().optional(),
        diastolic: joi.number().optional(),
        date: joi.date().optional(),
        notes: joi.string().max(500).optional()
    }).required()
};

export const addSymptomSchema = {
    body: joi.object({
        symptom: joi.string().required(),
        severity: joi.string().valid('none', 'mild', 'moderate', 'severe').optional(),
        date: joi.date().optional(),
        notes: joi.string().max(800).optional()
    }).required()
};
