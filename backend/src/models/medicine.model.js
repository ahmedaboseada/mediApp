import mongoose from 'mongoose';
import { feedbackLevels, medicineFrequency, medicineStatus, medicineTypes, weekDays } from '../config/CONSTANTS.js';

const { Schema, Types } = mongoose;

const weeklyBlockSchema = new Schema(
    { day: { type: String, enum: Object.values(weekDays), required: true }, times: [{ type: String }] },
    { _id: false },
);

const specificBlockSchema = new Schema(
    { day: { type: Date, required: true }, times: [{ type: String }] },
    { _id: false },
);

const takenSchema = new Schema(
    {
        time: { type: String, required: true },
        taken: { type: Boolean, default: false },
    },
    { _id: false },
);

const datesSchema = new Schema(
    {
        date: { type: Date, required: true },
        times: [takenSchema],
    },
    { _id: false },
);

const feedbackSchema = new Schema(
    {
        additionDate: { type: Date, default: Date.now },
        text: { type: String, trim: true, maxlength: 800 },
        level: { type: String, enum: Object.values(feedbackLevels), default: feedbackLevels.low },
    },
    { _id: false },
);

const medicineSchema = new Schema(
    {
        patientId: { type: Types.ObjectId, ref: 'Patient', index: true },

        type: { type: String, enum: Object.values(medicineTypes), required: true },

        frequency: { type: String, enum: Object.values(medicineFrequency), required: true },

        daily: [{ type: String }], // times

        weekly: [weeklyBlockSchema],

        specific: [specificBlockSchema],

        startDate: { type: Date },
        endDate: { type: Date },

        dosage: { type: String, trim: true, maxlength: 120 },
        stock: { type: Number, min: 0 },

        activeIngredient: { type: String, trim: true, maxlength: 160 },

        criticalMode: { type: Boolean, default: false },

        status: { type: String, enum: Object.values(medicineStatus), default: medicineStatus.normal, index: true },

        sideEffects: [{ type: String, trim: true, maxlength: 120 }], // enforce max 3 in validation/service

        dates: [datesSchema],

        notes: { type: String, trim: true, maxlength: 1200 },

        dailyFeedback: [feedbackSchema],
    },
    { timestamps: true, versionKey: false },
);

// enforce shape by frequency
medicineSchema.pre('validate', function (next) {
    if (this.frequency === medicineFrequency.daily) {
        this.weekly = [];
        this.specific = [];
        if (!this.daily?.length) return next(new Error('daily required for daily frequency'));
    }
    if (this.frequency === medicineFrequency.weekly) {
        this.daily = [];
        this.specific = [];
        if (!this.weekly?.length) return next(new Error('weekly required for weekly frequency'));
    }
    if (this.frequency === medicineFrequency.specific) {
        this.daily = [];
        this.weekly = [];
        if (!this.specific?.length) return next(new Error('specific required for specific frequency'));
    }
    next();
});

export default mongoose.model('Medicine', medicineSchema);
