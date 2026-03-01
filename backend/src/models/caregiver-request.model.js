import mongoose from 'mongoose';
const { Schema, Types } = mongoose;

const caregiverRequestSchema = new Schema(
    {
        patientId: { type: Types.ObjectId, ref: 'Patient', required: true, index: true },
        caregiverUserId: { type: Types.ObjectId, ref: 'User', required: true, index: true },

        relationship: { type: String, trim: true, maxlength: 60 },

        status: { type: String, enum: ['pending', 'accepted', 'rejected'], default: 'pending', index: true },
        respondedAt: { type: Date },
    },
    { timestamps: true }
);

caregiverRequestSchema.index({ patientId: 1, caregiverUserId: 1, status: 1 }, { unique: true });

export default mongoose.model('CaregiverRequest', caregiverRequestSchema);