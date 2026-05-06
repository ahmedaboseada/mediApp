import mongoose from 'mongoose';
const { Schema, Types } = mongoose;

const withdrawalRequestSchema = new Schema(
    {
        doctorId: { type: Types.ObjectId, ref: 'Doctor', required: true, index: true },
        amount: { type: Number, required: true, min: 10 },
        status: { type: String, enum: ['pending', 'approved', 'rejected', 'processed'], default: 'pending' },
        bankDetails: {
            bankName: { type: String, required: true },
            accountNumber: { type: String, required: true },
            accountHolderName: { type: String, required: true },
        },
        adminNotes: { type: String },
        processedAt: { type: Date }
    },
    { timestamps: true }
);

export default mongoose.model('WithdrawalRequest', withdrawalRequestSchema);
