import mongoose from 'mongoose';

const { Schema, Types } = mongoose;

const userSchema = new Schema(
    {
        type: { type: String, enum: ['user', 'patient', 'doctor', 'admin'], required: true, index: true },

        firstName: { type: String, required: true, trim: true, maxlength: 60 },
        lastName: { type: String, required: true, trim: true, maxlength: 60 },

        email: { type: String, required: true, lowercase: true, trim: true, unique: true, index: true },
        password: { type: String, required: true, select: false },

        phone: { type: String }, // encrypted
        DOB: { type: Date },
        age: { type: Number, min: 0, max: 130 },
        gender: { type: String, enum: ['male', 'female'] },

        twoFA: { type: Boolean, default: false },
        otp: { type: String, select: false }, // encrypted 6 digits (temporary)

        confirmed: { type: Boolean, default: false },

        // email change flow
        pendingEmail: { type: String, lowercase: true, trim: true },
        pendingEmailRequestedAt: { type: Date },

        // screen: profile picture
        profilePicture: { type: String, default: '' },

        notifications: [{ type: Types.ObjectId, ref: 'Notification' }],
        booking: [{ type: Types.ObjectId, ref: 'Booking' }],
        // Tokens and Expirations Tracking for Auth
        otpExpires: { type: Date, select: false },
        confirmTokenId: { type: String, select: false },
        resetTokenId: { type: String, select: false },
        emailChangeTokenId: { type: String, select: false },

        settings: {
            notifications: {
                push: { type: Boolean, default: true },
                email: { type: Boolean, default: true }
            },
            privacy: {
                allowCaregiverAccess: { type: Boolean, default: true },
                allowDoctorAccess: { type: Boolean, default: true }
            }
        }
    },
    { timestamps: true }
);

export default mongoose.model('User', userSchema);