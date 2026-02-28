import { customAlphabet } from 'nanoid';

export const otp6 = () => customAlphabet('0123456789', 6)();

import cron from 'node-cron';
import doctorModel from '../models/doctor.model.js';

export const startWeeklyAvailabilityReset = () => {
    // Saturday 23:59 (server timezone)
    cron.schedule('59 23 * * 6', async () => {
        await doctorModel.updateMany({}, { $set: { 'availability.$[].slots.$[].reserved': false } });
    });
};
