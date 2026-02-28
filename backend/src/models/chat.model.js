import mongoose from 'mongoose';
import { chatStatus } from '../config/CONSTANTS.js';

const { Schema, Types } = mongoose;

const chatSchema = new Schema(
    {
        name: { type: String, trim: true, maxlength: 120 },
        profileImage: { type: String, trim: true },
        status: { type: String, enum: Object.values(chatStatus), default: chatStatus.offline },

        messages: [{ type: Types.ObjectId, ref: 'Message' }],

        patientId: { type: Types.ObjectId, ref: 'Patient', index: true },
        doctorId: { type: Types.ObjectId, ref: 'Doctor', index: true },
    },
    { timestamps: true, versionKey: false },
);

export default mongoose.model('Chat', chatSchema);
