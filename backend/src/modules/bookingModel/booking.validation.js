import Joi from 'joi';

export const getSlotsSchema = {
    params: Joi.object({
        doctorId: Joi.string().hex().length(24).required(),
    }),
    query: Joi.object({
        date: Joi.date().iso().required(), // YYYY-MM-DD
    }),
};

export const createBookingSchema = {
    body: Joi.object({
        doctorId: Joi.string().hex().length(24).required(),
        date: Joi.date().iso().required(),
        time: Joi.string().pattern(/^([01]\d|2[0-3]):?([0-5]\d)$/).required(), // "HH:mm"

        packageType: Joi.string().valid('online', 'in-person').required(),
        bookingFor: Joi.string().default('Self'),
        patientAge: Joi.number().min(0).max(120),
        patientGender: Joi.string(),

        problem: Joi.string().max(1200).allow(''),
        
        // optional or default UI fields
        paymentMethod: Joi.string().default('cash_on_site'), // since no payment gateway for now
    }),
};

export const cancelBookingSchema = {
    params: Joi.object({
        id: Joi.string().hex().length(24).required(),
    }),
    body: Joi.object({
        cancelledReason: Joi.string().max(400).required(),
    }),
};

export const rescheduleBookingSchema = {
    params: Joi.object({
        id: Joi.string().hex().length(24).required(),
    }),
    body: Joi.object({
        date: Joi.date().iso().required(),
        time: Joi.string().pattern(/^([01]\d|2[0-3]):?([0-5]\d)$/).required(),
    }),
};
