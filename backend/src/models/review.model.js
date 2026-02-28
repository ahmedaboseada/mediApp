import mongoose from 'mongoose';

const { Schema, Types } = mongoose;

const reviewSchema = new Schema(
    {
        doctorId: { type: Types.ObjectId, ref: 'Doctor', required: true, index: true },
        PatientId: { type: Types.ObjectId, ref: 'Patient', required: true, index: true },
        rating: { type: Number, min: 1, max: 5, required: true },
    },
    { timestamps: true, versionKey: false },
);

reviewSchema.index({ doctorId: 1, PatientId: 1 }, { unique: true });

export default mongoose.model('Review', reviewSchema);
