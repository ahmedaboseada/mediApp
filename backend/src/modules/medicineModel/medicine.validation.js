import joi from 'joi';
import { medicineTypes, medicineFrequency, medicineStatus, weekDays, feedbackLevels } from '../../config/CONSTANTS.js';

const addMedicineBody = joi.object({
    type: joi.string().valid(...Object.values(medicineTypes)).required(),
    frequency: joi.string().valid(...Object.values(medicineFrequency)).required(),

    daily: joi.array().items(joi.string().pattern(/^([01]\d|2[0-3]):?([0-5]\d)$/)),
    weekly: joi.array().items(
        joi.object({
            day: joi.string().valid(...Object.values(weekDays)).required(),
            times: joi.array().items(joi.string().pattern(/^([01]\d|2[0-3]):?([0-5]\d)$/))
        })
    ),
    specific: joi.array().items(
        joi.object({
            day: joi.date().required(),
            times: joi.array().items(joi.string().pattern(/^([01]\d|2[0-3]):?([0-5]\d)$/))
        })
    ),

    startDate: joi.date().optional(),
    endDate: joi.date().optional(),
    expiryDate: joi.date().optional(),

    dosage: joi.string().max(120).optional(),
    stock: joi.number().min(0).optional(),
    leftThreshold: joi.number().min(0).optional(),
    isChronic: joi.boolean().optional(),

    name: joi.string().max(160).required(),
    criticalMode: joi.boolean().optional(),
    status: joi.string().valid(...Object.values(medicineStatus)).optional(),

    sideEffects: joi.array().items(joi.string().max(120)).max(3).optional(),
    notes: joi.string().max(1200).optional()
}).required();

export const addMedicineSchema = {
    body: addMedicineBody
};

export const updateMedicineSchema = {
    params: joi.object({ id: joi.string().hex().length(24).required() }).required(),
    body: addMedicineBody
};

export const deleteMedicineSchema = {
    params: joi.object({ id: joi.string().hex().length(24).required() }).required()
};

export const markAsTakenSchema = {
    params: joi.object({ id: joi.string().hex().length(24).required() }).required(),
    body: joi.object({
        time: joi.string().required(),
        date: joi.date().required(),
        taken: joi.boolean().required()
    }).required()
};

export const addLogSchema = {
    params: joi.object({ id: joi.string().hex().length(24).required() }).required(),
    body: joi.object({
        text: joi.string().max(800).required(),
        level: joi.string().valid(...Object.values(feedbackLevels)).optional()
    }).required()
};
