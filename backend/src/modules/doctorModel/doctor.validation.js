import joi from 'joi';

export const completeStep1Schema = {
    body: joi.object({
        specialization: joi.string().min(2).max(80).required(),
        clinicName: joi.string().min(2).max(160).required(),
        medicalLicenseId: joi.string().min(2).max(80).required(),

        phone: joi.string().required(),
        gender: joi.string().valid('male', 'female').required(),
        profilePicture: joi.string().uri().allow('', null),
    }),
};

export const completeLocationSchema = {
    body: joi.object({
        clinicAddress: joi.string().min(2).max(300).required(),
        clinicLocation: joi
            .object({
                lat: joi.number().required(),
                lng: joi.number().required(),
                label: joi.string().allow('', null),
            })
            .optional(),
    }),
};

export const completeScheduleSchema = {
    body: joi.object({
        workingDays: joi.array().items(joi.string()).min(1).required(),
        workingHours: joi
            .array()
            .items(joi.object({ startHour: joi.string().required(), endHour: joi.string().required() }))
            .min(1)
            .required(),
        consultationDuration: joi.number().valid(15, 30, 45, 60).required(),
    }),
};

export const completeAppointmentsSchema = {
    body: joi.object({
        appointmentTypes: joi.array().items(joi.string().valid('in-person', 'online')).min(1).required(),
        maxDailyPatients: joi.number().integer().min(1).max(500).required(),
    }),
};

export const completeLicenseSchema = {
    body: joi.object({
        licenseImage: joi.string().uri().allow('', null),
    }),
};

export const completeProfileSchema = {
    body: joi.object({
        specialization: joi.string().min(2).max(80).required(),
        clinicName: joi.string().min(2).max(160).required(),
        medicalLicenseId: joi.string().min(2).max(80).required(),
        phone: joi.string().required(),
        gender: joi.string().valid('male', 'female').required(),
        profilePicture: joi.string().uri().allow('', null),

        clinicAddress: joi.string().min(2).max(300).required(),
        clinicLocation: joi.object({
            lat: joi.number().required(),
            lng: joi.number().required(),
            label: joi.string().allow('', null),
        }).optional(),

        workingDays: joi.array().items(joi.string()).min(1).required(),
        workingHours: joi.array().items(joi.object({ startHour: joi.string().required(), endHour: joi.string().required() })).min(1).required(),
        consultationDuration: joi.number().valid(15, 30, 45, 60).required(),

        appointmentTypes: joi.array().items(joi.string().valid('in-person', 'online')).min(1).required(),
        maxDailyPatients: joi.number().integer().min(1).max(500).required(),

        licenseImage: joi.string().uri().allow('', null),
    }),
};