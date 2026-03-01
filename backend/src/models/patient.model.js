import mongoose from 'mongoose';
const { Schema, Types } = mongoose;

const emergencyContactSchema = new Schema(
    {
        name: { type: String, trim: true, maxlength: 120 },
        phone: { type: String, trim: true, maxlength: 40 },
        contactMethod: { type: String, enum: ['sms', 'whatsapp'] },
    },
    { _id: false }
);

const caregiverSchema = new Schema(
    {
        giving: [{ type: Types.ObjectId, ref: 'Patient' }], // caregiver manages those patients
        taking: { type: Types.ObjectId, ref: 'User' }, // who manages THIS patient
        caregivingOption: { type: Boolean, default: false },
    },
    { _id: false }
);

const healthMeasurementsSchema = new Schema(
    {
        systolic: [{ type: Number }],
        diastolic: [{ type: Number }],
        glucose: [{ type: Number }],
        weight: [{ type: Number }],
        lastEdit: { type: Date },
    },
    { _id: false }
);

const patientSchema = new Schema(
    {
        userId: { type: Types.ObjectId, ref: 'User', required: true, unique: true, index: true },

        chronicConditions: [{ type: String }],
        allergies: [{ type: String }],
        activeIngredients: [{ type: String }],
        longTermMedication: [{ type: String }],

        medications: [{ type: Types.ObjectId, ref: 'Medicine' }],

        connectedDoctors: [
            {
                doctorId: { type: Types.ObjectId, ref: 'Doctor' },
                status: { type: String, default: 'pending', index: true },
            },
        ],

        // payment card (optional screen later)
        card: { type: String },
        expiryDate: { type: String },
        saveOption: { type: Boolean, default: false },

        bloodTypes: { type: String }, // keep enum later if you have list
        emergencyContact: emergencyContactSchema,

        // patient screen: caregiver mode
        caregiver: caregiverSchema,

        // screen flags
        reactionToMedication: { type: Boolean },
        allergyAlerts: { type: Boolean },

        healthMeasurements: healthMeasurementsSchema,
    },
    { timestamps: true }
);

export default mongoose.model('Patient', patientSchema);