import joi from 'joi';
import { Types } from 'mongoose';

const isValidObjectId = (value, helper) => {
    return Types.ObjectId.isValid(value) ? true : helper.message('Invalid ObjectId');
};

export const doctorIdSchema = {
    params: joi
        .object({
            id: joi.string().custom(isValidObjectId).required(),
        })
        .required(),
};
