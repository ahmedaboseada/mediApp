import mongoose from 'mongoose';

const { Schema, Types } = mongoose;

const auditLogSchema = new Schema(
    {
        patientId: { type: Types.ObjectId, ref: 'Patient', required: true, index: true },
        doctorId: { type: Types.ObjectId, ref: 'Doctor', required: true, index: true },
        bookingId: { type: Types.ObjectId, ref: 'Booking', index: true },
        action: { type: String, enum: ['add_medicine', 'modify_medicine', 'delete_medicine', 'edit_health'], required: true },
        details: { type: String, required: true },
    },
    { timestamps: true, versionKey: false },
);

export default mongoose.model('AuditLog', auditLogSchema);
