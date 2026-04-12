import mongoose from 'mongoose';
import { notificationTypes } from '../config/CONSTANTS.js';

const { Schema, Types } = mongoose;

const notificationSchema = new Schema(
    {
        type: { type: String, enum: Object.values(notificationTypes), required: true, index: true },
        header: { type: String, trim: true, maxlength: 120 },
        message: { type: String, trim: true, maxlength: 800 },
        time: { type: Date, default: Date.now, index: true },
        read: { type: Boolean, default: false, index: true },
        userId: { type: Types.ObjectId, ref: 'User', required: true, index: true },
    },
    { timestamps: true, versionKey: false },
);

export default mongoose.model('Notification', notificationSchema);
