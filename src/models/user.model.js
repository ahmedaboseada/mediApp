import mongoose from "mongoose";
import * as constants from "../config/CONSTANTS.js";

const userSchema = new mongoose.Schema({
    username: { type: String, required: true, unique: true },
    email: { type: String, required: true, unique: true },
    emailConfirmed: { type: Boolean, default: false },
    password: { type: String, required: true },
    phoneNumber: { type: String, unique: true },
    picture: { type: String }, // profile picture url
    language: { type: String, default: "en" },
    gender: { type: String, required: true, enum: [constants.userGender], default: constants.userGender.male },
    // Gamification
    points: { type: Number, default: 0 },
    level: { type: Number, default: 1, max: 10 },
    badges: [{ type: String }], // array of achievements
    coins: { type: Number, default: 0 },

    // Subscription
    subscription: {
        type: {
            plan: { type: String, enum: [constants.subscriptionPlans], default: constants.subscriptionPlans.free },
            startDate: { type: Date },
            endDate: { type: Date },
            autoRenew: { type: Boolean, default: constants.subscriptionAutoRenew.false },
        },
        default: { plan: constants.subscriptionPlans.free }
    },

    // Insights / Stats
    stats: {
        totalTasks: { type: Number, default: 0 },
        completedTasks: { type: Number, default: 0 },
        productiveDays: [{ type: String }], // e.g. ["Monday", "Tuesday"]
        bestTimeOfDay: { type: String }, // e.g. "21:00"
        avgCompletionDelay: { type: String } // e.g. "2h"
    },
    role: { type: String, enum: [constants.userRole], default: constants.userRole.user },

    createdAt: { type: Date, default: Date.now }
});

export default mongoose.model("User", userSchema);
