import joi from 'joi';


export const signupSchema = {
    body: joi.object({
        type: joi.string().valid("user", "patient", "doctor").required(),

        firstName: joi.string().min(2).max(60).required(),
        lastName: joi.string().min(2).max(60).required(),
        username: joi.string(),
        email: joi.string().email().required(),

        password: joi.string()
            .required()
            .pattern(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$/)
            .messages({
                "string.pattern.base":
                    "Password must be at least 8 characters long and contain uppercase, lowercase, number, and special character",
            }),

        confirmPassword: joi.string()
            .required()
            .valid(joi.ref("password"))
            .messages({ "any.only": "Passwords do not match" }),

        // optional at signup (because screens fill later)
        twoFA: joi.boolean().optional(),
    }),
};
export const signinSchema = {
    body: joi.object({
        email: joi.string().email().required(),
        password: joi.string().required(),
    }),
};

export const signinOtpSchema = {
    body: joi.object({
        challengeToken: joi.string().required(),
        otp: joi.string().pattern(/^\d{6}$/).required(),
    }),
};

export const forgetPasswordSchema = {
    body: joi.object({
        email: joi.string().email().required(),
    }),
};

export const verifyForgetPasswordOTPSchema = {
    body: joi.object({
        email: joi.string().email().required(),
        otp: joi.string().pattern(/^\d{6}$/).required(),
    }),
};

export const changeEmailSchema = {
    body: joi.object({
        newEmail: joi.string().email().required(),
    }),
};

export const toggle2FASchema = {
    body: joi.object({
        enabled: joi.boolean().required(),
    }),
};

export const getProfileSchema = {
    params: joi.object({
        id: joi.string().hex().length(24).required(),
    }),
};

export const confirmEmailChangeSchema = {
    params: joi.object({
        token: joi.string().required(),
    }),
};

export const changePasswordSchema = {
    body: joi.object({
        oldPassword: joi.string().required(),
        newPassword: joi.string()
            .required()
            .pattern(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$/)
            .messages({
                "string.pattern.base":
                    "Password must be at least 8 characters long and contain uppercase, lowercase, number, and special character",
            }),
        confirmPassword: joi.string()
            .required()
            .valid(joi.ref("newPassword"))
            .messages({ "any.only": "Passwords do not match" }),
    }),
};

export const resetPasswordSchema = {
    body: joi.object({
        resetToken: joi.string().required(),
        newPassword: joi.string()
            .required()
            .pattern(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$/)
            .messages({
                "string.pattern.base":
                    "Password must be at least 8 characters long and contain uppercase, lowercase, number, and special character",
            }),
        confirmPassword: joi.string()
            .required()
            .valid(joi.ref("newPassword"))
            .messages({ "any.only": "Passwords do not match" }),
    }),
};