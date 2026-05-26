import joi from 'joi';

export const createReviewSchema = {
    body: joi.object({
        doctorId: joi.string().hex().length(24).required(),
        rating: joi.number().min(1).max(5).required(),
    }),
};

export const updateReviewSchema = {
    params: joi.object({
        id: joi.string().hex().length(24).required(),
    }),
    body: joi.object({
        rating: joi.number().min(1).max(5).required(),
    }),
};

export const getReviewSchema = {
    params: joi.object({
        id: joi.string().hex().length(24).required(),
    }),
};

export const getDoctorReviewsSchema = {
    params: joi.object({
        doctorId: joi.string().hex().length(24).required(),
    }),
};
