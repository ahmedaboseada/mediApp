import express from 'express';
import connectDB from './config/DB.js';
import cors from 'cors';
import morgan from 'morgan';
import helmet from 'helmet';
import { rateLimit } from 'express-rate-limit';

import userRouter from './modules/userModel/user.controller.js';
import messageRouter from './modules/messageModel/message.controller.js';
import { notFound } from './middlewares/notFound.js';
import { errorHandler } from './middlewares/errorHandler.js';
import mongoose from 'mongoose';
import patientRouter from './modules/patientModel/patient.controller.js';
import doctorRouter from './modules/doctorModel/doctor.controller.js';
import adminRouter from './modules/adminModel/admin.controller.js';
import medicineRouter from './modules/medicineModel/medicine.controller.js';
import healthRouter from './modules/healthModel/health.controller.js';
import bookingRouter from './modules/bookingModel/booking.routes.js';


import { startWeeklyAvailabilityReset } from './utils/index.js';

const app = express();

export const bootstrap = async () => {
    await connectDB();
    // inside bootstrap after DB connect
    startWeeklyAvailabilityReset();

    app.use(express.json({ limit: '100kb' }));
    app.use(express.urlencoded({ extended: true, limit: '100kb' }));

    app.use(cors());
    app.use(morgan('dev'));

    app.use(
        helmet({
            contentSecurityPolicy: false,
            crossOriginEmbedderPolicy: false,
        }),
    );

    const limiter = rateLimit({
        windowMs: 1 * 60 * 1000,
        limit: 60,
        standardHeaders: 'draft-7',
        legacyHeaders: false,
        handler: (req, res, next) => next(Object.assign(new Error('Too many requests'), { status: 429 })),
    });
    app.use(limiter);


    app.get(['/health', '/api/v1/health'], (req, res) => {
        const state = mongoose.connection.readyState; // 0=disconnected,1=connected,2=connecting,3=disconnecting
        const db =
            state === 1 ? 'connected' : state === 2 ? 'connecting' : state === 3 ? 'disconnecting' : 'disconnected';
        res.status(200).json({
            ok: true,
            service: 'MediProject',
            env: process.env.NODE_ENV,
            db,
            timestamp: new Date().toISOString(),
        });
    });

    app.use('/users', userRouter);
    app.use('/messages', messageRouter);
    app.use('/patients', patientRouter);
    app.use('/doctors', doctorRouter);
    app.use('/admin', adminRouter);
    app.use('/medications', medicineRouter);
    app.use('/health', healthRouter);
    app.use('/bookings', bookingRouter);



    app.use('/uploads', express.static('uploads'));

    app.use(notFound);
    app.use(errorHandler);

    if (!process.env.VERCEL) {
        const PORT = process.env.PORT || 3000;
        app.listen(PORT, () => console.log(`Server is running on port ${PORT}`));
    }

    return app;
};
