import mongoose from 'mongoose';
import { feedbackLevels } from '../config/CONSTANTS.js';

const { Schema, Types } = mongoose;

const symptomLogSchema = new Schema(
    {
        patientId: { type: Types.ObjectId, ref: 'Patient', required: true, index: true },

        symptoms: [{ type: String, trim: true }], // e.g., ['Headache', 'Fatigue', 'Nausea']
        severity: {
            type: String,
            enum: ['none', 'mild', 'moderate', 'severe'],
            default: 'mild'
        },

        date: { type: Date, default: Date.now, required: true },
        notes: { type: String, trim: true, maxlength: 800 }
    },
    { timestamps: true, versionKey: false }
);

export default mongoose.model('SymptomLog', symptomLogSchema);
