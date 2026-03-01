import mongoose from 'mongoose';
import { messageStatus } from '../config/CONSTANTS.js';

const { Schema, Types } = mongoose;

const fileSchema = new Schema(
    {
        type: { type: String, enum: ['image', 'pdf'], required: true },
        url: { type: String, required: true },
        name: { type: String, trim: true, maxlength: 200 },
    },
    { _id: false },
);

const voiceNoteSchema = new Schema(
    {
        type: { type: String, enum: ['audio'], default: 'audio' },
        url: { type: String },
        duraction: { type: Number, min: 0 }, // keep your field name
    },
    { _id: false },
);

const messageSchema = new Schema(
    {
        senderId: { type: Types.ObjectId, ref: 'User', required: true, index: true },
        receiverId: { type: Types.ObjectId, ref: 'User', required: true, index: true },

        message: { type: String, trim: true, maxlength: 2000 },

        time: { type: Date, default: Date.now, index: true },

        status: { type: String, enum: Object.values(messageStatus), default: messageStatus.unseen, index: true },

        files: [fileSchema],

        voiceNote: voiceNoteSchema,
    },
    { timestamps: true, versionKey: false },
);

export default mongoose.model('Message', messageSchema);
