import mongoose from 'mongoose';
import crypto from 'crypto';
import { bookingStatus } from '../config/CONSTANTS.js';

const { Schema, Types } = mongoose;

const dateSchema = new Schema(
    {
        date: { type: Date, required: true },
        time: { type: String, required: true }, // "HH:mm"
    },
    { _id: false },
);

const bookingSchema = new Schema(
    {
        patientId: { type: Types.ObjectId, ref: 'Patient', required: true, index: true },
        doctorId: { type: Types.ObjectId, ref: 'Doctor', required: true, index: true },

        date: dateSchema,

        duration: { type: Number, min: 15, max: 240 },

        packageType: { type: String, enum: ['online', 'in-person'] }, // strict validation
        bookingFor: { type: String, trim: true, default: 'Self' },
        reserverName: { type: String, trim: true },
        patientAge: { type: Number },
        patientGender: { type: String },

        problem: { type: String, trim: true, maxlength: 1200 },

        paymentMethod: { type: String, trim: true, maxlength: 40 },
        paymentStatus: { type: String, enum: ['pending', 'paid', 'failed', 'refunded'], default: 'pending' },
        price: { type: Number, min: 0 },

        appointmentId: { type: String, unique: true, index: true },
        
        sessionToken: { type: String, index: true },
        sessionActive: { type: Boolean, default: false },
        sessionExpiresAt: { type: Date },

        status: { type: String, enum: Object.values(bookingStatus), default: bookingStatus.upcoming, index: true },

        clinicAddress: { type: String, trim: true, maxlength: 300 },

        cancelledReason: { type: String, trim: true, maxlength: 400 },
    },
    { timestamps: true, versionKey: false },
);

bookingSchema.pre('validate', function () {
    if (!this.appointmentId) this.appointmentId = crypto.randomBytes(8).toString('hex');
});

bookingSchema.index({ doctorId: 1, 'date.date': 1, 'date.time': 1 });

export default mongoose.model('Booking', bookingSchema);
