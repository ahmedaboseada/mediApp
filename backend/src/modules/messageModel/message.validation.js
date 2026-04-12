import joi from 'joi';

export const sendMessageSchema = {
    body: joi.object({
        receiverId: joi.string().hex().length(24).required(),
        message: joi.string().trim().min(1).max(2000).required(),

        // optional spec fields
        files: joi.array().items(
            joi.object({
                type: joi.string().valid('image', 'pdf').required(),
                url: joi.string().required(),
                name: joi.string().allow('').optional(),
            })
        ).optional(),

        voiceNote: joi.object({
            type: joi.string().valid('audio').default('audio'),
            url: joi.string().required(),
            duraction: joi.number().min(0).required(),
        }).optional(),
    }),
};
