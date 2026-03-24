import mongoose from 'mongoose';

const { Schema, Types } = mongoose;

const healthMeasurementSchema = new Schema(
    {
        patientId: { type: Types.ObjectId, ref: 'Patient', required: true, index: true },

        type: {
            type: String,
            enum: ['blood_pressure', 'blood_sugar', 'weight', 'heart_rate'],
            required: true
        },

        value: { type: Number }, // For single values like weight, heart_rate, blood_sugar
        systolic: { type: Number }, // For blood pressure
        diastolic: { type: Number }, // For blood pressure
        heartRate: { type: Number }, // For combined blood pressure measurements

        date: { type: Date, default: Date.now, required: true },
        notes: { type: String, trim: true, maxlength: 500 }
    },
    { timestamps: true, versionKey: false }
);

export default mongoose.model('HealthMeasurement', healthMeasurementSchema);
