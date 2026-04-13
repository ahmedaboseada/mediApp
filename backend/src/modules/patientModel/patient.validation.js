import joi from 'joi';

export const completeBasicSchema = {
    body: joi.object({
        phone: joi.string().required(),
        yearOfBirth: joi.number().integer().min(1900).max(new Date().getFullYear()).required(),
        gender: joi.string().valid('male', 'female').required(),
        profilePicture: joi.string().uri().allow('', null),
    }),
};

export const completeHealth1Schema = {
    body: joi.object({
        chronicConditions: joi.array().items(joi.string()).default([]),
        longTermMedication: joi.array().items(joi.string()).default([]),
        activeIngredients: joi.array().items(joi.string()).default([]),
    }),
};

export const completeHealth2Schema = {
    body: joi.object({
        allergies: joi.array().items(joi.string()).default([]),
        reactionToMedication: joi.boolean().required(),
        allergyAlerts: joi.boolean().required(),
    }),
};

export const completeProfileSchema = {
    body: joi.object({
        phone: joi.string().required(),
        yearOfBirth: joi.number().integer().min(1900).max(new Date().getFullYear()).required(),
        gender: joi.string().valid('male', 'female').required(),
        profilePicture: joi.string().uri().allow('', null),

        chronicConditions: joi.array().items(joi.string()).default([]),
        longTermMedication: joi.array().items(joi.string()).default([]),
        activeIngredients: joi.array().items(joi.string()).default([]),

        allergies: joi.array().items(joi.string()).default([]),
        reactionToMedication: joi.boolean().required(),
        allergyAlerts: joi.boolean().required(),
    }),
};

export const caregiverOptionSchema = {
    body: joi.object({
        caregivingOption: joi.boolean().required(),
    }),
};

export const caregiverRequestSchema = {
    body: joi.object({
        caregiverEmail: joi.string().email().required(),
        relationship: joi.string().min(2).max(60).required(),
    }),
};

export const requestIdSchema = {
    params: joi.object({
        requestId: joi.string().hex().length(24).required(),
    }),
};

export const connectDoctorSchema = {
    body: joi.object({
        doctorId: joi.string().hex().length(24).required(),
    }),
};