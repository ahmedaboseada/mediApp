import mongoose from 'mongoose';
const { Schema, Types } = mongoose;

const workingHoursSchema = new Schema(
    { startHour: { type: String }, endHour: { type: String } },
    { _id: false }
);

const clinicLocationSchema = new Schema(
    { lat: Number, lng: Number, label: String },
    { _id: false }
);

const doctorSchema = new Schema(
    {
        userId: { type: Types.ObjectId, ref: 'User', required: true, unique: true, index: true },

        specialization: { type: String, index: true }, // required only at step1, enforce in Joi
        clinicName: { type: String, trim: true, maxlength: 160 },
        medicalLicenseId: { type: String, trim: true, maxlength: 80 },

        clinicAddress: { type: String, trim: true, maxlength: 300 },
        clinicLocation: clinicLocationSchema,

        workingDays: [{ type: String }], // enum later
        workingHours: [workingHoursSchema],

        consultationDuration: { type: Number, enum: [15, 30, 45, 60] },

        appointmentTypes: [{ type: String, enum: ['in-person', 'online'] }],
        maxDailyPatients: { type: Number, min: 1, max: 500 },

        // encrypted fields
        licenseImage: { type: String, select: false }, // encrypted url

        connectedPatients: [
            { patientId: { type: Types.ObjectId, ref: 'Patient' }, status: { type: String, default: 'pending' } },
        ],

        reviews: [{ type: Types.ObjectId, ref: 'Review' }],
        reviewsCount: { type: Number, default: 0 },
    },
    { timestamps: true }
);

export default mongoose.model('Doctor', doctorSchema);