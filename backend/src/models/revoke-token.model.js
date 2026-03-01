import mongoose from 'mongoose';

const revokeTokenSchema = new mongoose.Schema(
    {
        tokenId: { type: String, required: true, unique: true, index: true }, // jti
        expiredAt: { type: Date, required: true },
    },
    { timestamps: true, versionKey: false },
);

revokeTokenSchema.index({ expiredAt: 1 }, { expireAfterSeconds: 0 });

export const revokeTokenModel = mongoose.model('RevokeToken', revokeTokenSchema);
