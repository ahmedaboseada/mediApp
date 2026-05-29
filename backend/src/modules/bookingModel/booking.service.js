import bookingModel from '../../models/booking.model.js';
import doctorModel from '../../models/doctor.model.js';
import patientModel from '../../models/patient.model.js';
import notificationModel from '../../models/notification.model.js';
import userModel from '../../models/user.model.js';
import healthMeasurementModel from '../../models/health-measurement.model.js';
import * as ET from '../../utils/encryption/index.js';
import { createPaymentIntention } from '../../utils/paymob.js';

// --- Time Helpers ---
const timeToMins = (t) => {
    const [h, m] = t.split(':').map(Number);
    return h * 60 + m;
};
const minsToTime = (m) => {
    const hh = Math.floor(m / 60).toString().padStart(2, '0');
    const mm = (m % 60).toString().padStart(2, '0');
    return `${hh}:${mm}`;
};

export const getDoctorSlots = async (req, res) => {
    const { doctorId } = req.params;
    const { date } = req.query;

    const doc = await doctorModel.findById(doctorId).lean();
    if (!doc) return res.status(404).json({ message: 'Doctor not found' });
    // Note: status check if you want them to be 'approved' only
    // if (doc.status !== 'approved') return res.status(403).json({ message: 'Doctor is not available' });

    const reqDate = new Date(date);
    if (isNaN(reqDate)) return res.status(400).json({ message: 'Invalid Date' });

    const days = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];
    const dayName = days[reqDate.getUTCDay()];

    if (!doc.workingDays?.includes(dayName)) {
        return res.status(200).json({ slots: [] }); // Doctor doesn't work this day
    }

    const startOfDay = new Date(reqDate);
    startOfDay.setUTCHours(0, 0, 0, 0);
    const endOfDay = new Date(startOfDay);
    endOfDay.setUTCHours(23, 59, 59, 999);

    const existingBookings = await bookingModel.find({
        doctorId,
        'date.date': { $gte: startOfDay, $lte: endOfDay },
        status: { $in: ['upcoming', 'completed'] }
    }).lean();

    if (doc.maxDailyPatients && existingBookings.length >= doc.maxDailyPatients) {
        return res.status(200).json({ slots: [] }); // Fully booked
    }

    const duration = doc.consultationDuration || 30; // fallback default
    const reservedTimes = existingBookings.map(b => b.date.time);

    let slots = [];
    if (doc.workingHours && doc.workingHours.length > 0) {
        for (const block of doc.workingHours) {
            const startMins = timeToMins(block.startHour);
            const endMins = timeToMins(block.endHour);

            // iterate exact slots fitting the duration
            for (let t = startMins; t + duration <= endMins; t += duration) {
                const timeStr = minsToTime(t);
                if (!reservedTimes.includes(timeStr)) {
                    slots.push(timeStr);
                }
            }
        }
    }

    return res.status(200).json({ slots });
};

export const createBooking = async (req, res) => {
    // 1. Context Resolution
    const patientUserId = req.user.id;
    const patient = await patientModel.findOne({ userId: patientUserId });
    if (!patient) return res.status(404).json({ message: 'Patient profile required' });

    const { doctorId, date, time, packageType, bookingFor, patientAge, patientGender, problem, paymentMethod } = req.body;

    const doc = await doctorModel.findById(doctorId).lean();
    if (!doc) return res.status(404).json({ message: 'Doctor not found' });

    // 2. Validate Package / Appointment Type
    if (doc.appointmentTypes && doc.appointmentTypes.length > 0) {
        if (!doc.appointmentTypes.includes(packageType)) {
            return res.status(400).json({ message: `Doctor does not support '${packageType}' package` });
        }
    }

    // 3. Double Booking / Validation Checks
    const reqDate = new Date(date);
    const dayName = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'][reqDate.getUTCDay()];

    if (!doc.workingDays?.includes(dayName)) {
        return res.status(400).json({ message: 'Doctor does not work on this day' });
    }

    const startOfDay = new Date(reqDate); startOfDay.setUTCHours(0, 0, 0, 0);
    const endOfDay = new Date(startOfDay); endOfDay.setUTCHours(23, 59, 59, 999);

    const existingBookings = await bookingModel.find({
        doctorId,
        'date.date': { $gte: startOfDay, $lte: endOfDay },
        status: { $in: ['upcoming', 'completed'] }
    }).lean();

    if (doc.maxDailyPatients && existingBookings.length >= doc.maxDailyPatients) {
        return res.status(400).json({ message: 'Doctor is fully booked for this day' });
    }

    const isTaken = existingBookings.some(b => b.date.time === time);
    if (isTaken) {
        return res.status(409).json({ message: 'This slot is already reserved.' });
    }

    // 4. Booking Object Creation
    const booking = await bookingModel.create({
        patientId: patient._id,
        doctorId: doc._id,
        date: { date: startOfDay, time },
        duration: doc.consultationDuration || 30,
        packageType,
        bookingFor,
        patientAge,
        patientGender,
        problem,
        paymentMethod: paymentMethod || 'cash_on_site',
        price: doc.consultationPrice || 0, // Fallback if schema doesn't have it defined
        status: 'upcoming',
        clinicAddress: doc.clinicAddress || ''
    });

    let paymentUrl = null;
    let clientSecret = null;
    let intentionId = null;

    if (paymentMethod === 'card' || paymentMethod === 'online' || paymentMethod === 'paymob') {
        const user = await userModel.findById(patientUserId);
        const billingData = {
            first_name: user?.firstName || 'Patient',
            last_name: user?.lastName || 'Name',
            email: user?.email || 'patient@example.com',
            phone_number: user?.phone || '+201000000000',
        };

        try {
            const paymobData = await createPaymentIntention({
                amount: booking.price > 0 ? booking.price : 100, // Handle 0 price fallback
                billingData,
                orderId: booking._id,
            });
            paymentUrl = paymobData.checkoutUrl;
            clientSecret = paymobData.clientSecret;
            intentionId = paymobData.intentionId;
        } catch (error) {
            console.error("Paymob creation failed", error);
        }
    }

    // 5. Connect mappings (if appropriate to embed locally)
    if (!patient.connectedDoctors.find(d => String(d.doctorId) === String(doc._id))) {
        patient.connectedDoctors.push({ doctorId: doc._id, status: 'approved' });
        await patient.save();
    }

    await notificationModel.create({
        type: 'bookingReschedule', // generic scheduling trigger template
        header: 'New Appointment',
        message: `Your appointment is confirmed for ${date} at ${time}.`,
        userId: patientUserId,
    });

    return res.status(201).json({
        message: 'Booking confirmed!',
        booking,
        paymentUrl,
        clientSecret,
        intentionId
    });
};

export const getMyBookingsAsPatient = async (req, res) => {
    const patientUserId = req.user.id;
    const patient = await patientModel.findOne({ userId: patientUserId });
    if (!patient) return res.status(404).json({ message: 'Patient not found' });

    const bookings = await bookingModel.find({ patientId: patient._id })
        .populate({
            path: 'doctorId',
            populate: {
                path: 'userId'
            }
        })
        .sort({ 'date.date': -1, 'date.time': -1 })
        .lean();

    return res.status(200).json({ bookings });
};

export const getMyBookingsAsDoctor = async (req, res) => {
    const doctorUserId = req.user.id;
    const { date } = req.query;

    const doc = await doctorModel.findOne({ userId: doctorUserId });
    if (!doc) return res.status(404).json({ message: 'Doctor not found' });

    let filter = { doctorId: doc._id };

    if (date) {
        const reqDate = new Date(date);
        if (!isNaN(reqDate)) {
            const startOfDay = new Date(reqDate); startOfDay.setUTCHours(0, 0, 0, 0);
            const endOfDay = new Date(startOfDay); endOfDay.setUTCHours(23, 59, 59, 999);
            filter['date.date'] = { $gte: startOfDay, $lte: endOfDay };
        }
    }

    const bookings = await bookingModel.find(filter)
        .populate('patientId')
        .sort({ 'date.date': -1, 'date.time': -1 })
        .lean();

    return res.status(200).json({ bookings });
};

export const getBookingDetails = async (req, res) => {
    const userId = req.user.id;
    const { id } = req.params;

    const booking = await bookingModel.findById(id)
        .populate('patientId')
        .populate('doctorId')
        .lean();

    if (!booking) return res.status(404).json({ message: 'Booking not found' });

    // Ensure the requester is either the bound patient or the bound doctor
    let authorized = false;

    // Check if user is the patient
    const patient = await patientModel.findOne({ userId });
    if (patient && String(booking.patientId._id || booking.patientId) === String(patient._id)) authorized = true;

    // Check if user is the doctor
    const doc = await doctorModel.findOne({ userId });
    if (doc && String(booking.doctorId._id || booking.doctorId) === String(doc._id)) authorized = true;

    if (!authorized) return res.status(403).json({ message: 'Access denied' });

    return res.status(200).json({ booking });
};

export const cancelBooking = async (req, res) => {
    const userId = req.user.id;
    const { id } = req.params;
    const { cancelledReason } = req.body;

    const patient = await patientModel.findOne({ userId });
    // Assuming UI flows only allow user themselves to trigger this, strict check:
    const booking = await bookingModel.findById(id);
    if (!booking) return res.status(404).json({ message: 'Booking not found' });

    if (String(booking.patientId) !== String(patient?._id)) {
        return res.status(403).json({ message: 'Access denied' });
    }

    if (booking.status === 'cancelled' || booking.status === 'completed') {
        return res.status(400).json({ message: `Cannot cancel a ${booking.status} booking.` });
    }

    booking.status = 'cancelled';
    booking.cancelledReason = cancelledReason;
    await booking.save();

    await notificationModel.create({
        type: 'bookingCancel',
        header: 'Appointment Cancelled',
        message: `Your appointment has been cancelled successfully.`,
        userId: userId,
    });

    return res.status(200).json({ message: 'Booking cancelled successfully', booking });
};

// Rescheduling essentially acts as a cancel + book or just mutation
export const rescheduleBooking = async (req, res) => {
    const patientUserId = req.user.id;
    const { id } = req.params;
    const { date, time } = req.body;

    const patient = await patientModel.findOne({ userId: patientUserId });
    const booking = await bookingModel.findById(id);

    if (!booking) return res.status(404).json({ message: 'Booking not found' });
    if (String(booking.patientId) !== String(patient?._id)) return res.status(403).json({ message: 'Access denied' });
    if (booking.status !== 'upcoming') return res.status(400).json({ message: 'Only upcoming bookings can be rescheduled.' });

    const doc = await doctorModel.findById(booking.doctorId).lean();

    // Validate the new requested slot
    const reqDate = new Date(date);
    const dayName = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'][reqDate.getUTCDay()];
    if (!doc.workingDays?.includes(dayName)) return res.status(400).json({ message: 'Doctor does not work on this day' });

    const startOfDay = new Date(reqDate); startOfDay.setUTCHours(0, 0, 0, 0);
    const endOfDay = new Date(startOfDay); endOfDay.setUTCHours(23, 59, 59, 999);

    const existingBookings = await bookingModel.find({
        doctorId: doc._id,
        'date.date': { $gte: startOfDay, $lte: endOfDay },
        status: { $in: ['upcoming', 'completed'] },
        _id: { $ne: booking._id } // exclude current booking
    }).lean();

    const isTaken = existingBookings.some(b => b.date.time === time);
    if (isTaken) return res.status(409).json({ message: 'This slot is already reserved.' });

    const updatedBooking = await bookingModel.findByIdAndUpdate(
        booking._id,
        { 'date.date': startOfDay, 'date.time': time },
        { new: true }
    );

    await notificationModel.create({
        type: 'bookingReschedule',
        header: 'Appointment Rescheduled',
        message: `Your appointment was rescheduled to ${date} at ${time}.`,
        userId: patientUserId,
    });

    return res.status(200).json({ message: 'Booking rescheduled successfully', booking: updatedBooking });
};

export const paymobWebhook = async (req, res) => {
    try {
        const data = req.body;
        console.log('--- Paymob Webhook Received ---');
        console.log(JSON.stringify(data, null, 2));

        if (data && data.obj && data.obj.success === true) {
            // Retrieve booking ID from either merchant_order_id or special_reference depending on webhook type
            const orderId = data.obj.order?.merchant_order_id || data.obj.order?.special_reference || data.obj.payment_key_claims?.billing_data?.special_reference;

            if (orderId) {
                const booking = await bookingModel.findById(orderId);
                if (booking && booking.paymentStatus !== 'paid') {
                    booking.paymentStatus = 'paid';
                    await booking.save();
                    console.log(`Payment successful for Order/Booking ID: ${orderId}`);
                    
                    // Credit doctor's wallet (MVP)
                    const doctor = await doctorModel.findById(booking.doctorId);
                    if (doctor && booking.price) {
                        doctor.walletBalance += booking.price;
                        await doctor.save();
                    }
                }
            }
        }

        // Always return 200 OK to Paymob to acknowledge receipt
        return res.status(200).send('Webhook processed');
    } catch (error) {
        console.error('Paymob Webhook Error:', error);
        return res.status(500).send('Webhook Error');
    }
};

export const paymobCallbackRedirect = async (req, res) => {
    const { success } = req.query;

    if (success === 'true') {
        return res.redirect('medi://payment/return?status=success');
    } else {
        return res.redirect('medi://payment/return?status=failure');
    }
};

export const generateSessionToken = async (req, res) => {
    const patientUserId = req.user.id;
    const { bookingId } = req.params;

    const patient = await patientModel.findOne({ userId: patientUserId });
    const booking = await bookingModel.findById(bookingId);

    if (!booking) return res.status(404).json({ message: 'Booking not found' });
    if (String(booking.patientId) !== String(patient?._id)) return res.status(403).json({ message: 'Access denied' });

    // Session starts only if booking is paid (or cash on site)
    if (['online', 'card', 'paymob'].includes(booking.paymentMethod) && booking.paymentStatus !== 'paid') {
        return res.status(400).json({ message: 'Cannot start session. Booking is not paid yet.' });
    }

    import('crypto').then(async (crypto) => {
        const token = crypto.randomBytes(16).toString('hex');
        booking.sessionToken = token;
        booking.sessionActive = false; // Not active until doctor scans it
        await booking.save();
        return res.status(200).json({ message: 'QR Token generated', sessionToken: token });
    });
};

export const startSession = async (req, res) => {
    const doctorUserId = req.user.id;
    const { sessionToken } = req.body;

    const doc = await doctorModel.findOne({ userId: doctorUserId });
    if (!doc) return res.status(404).json({ message: 'Doctor not found' });

    const booking = await bookingModel.findOne({ sessionToken });
    if (!booking) return res.status(404).json({ message: 'Invalid or expired session token' });

    if (String(booking.doctorId) !== String(doc._id)) {
        return res.status(403).json({ message: 'This token is not meant for you' });
    }

    if (!booking.patientId) return res.status(400).json({ message: 'Invalid or expired session token' });
    
    const patient = await patientModel.findById(booking.patientId)
        .populate('userId', 'firstName lastName email type DOB age gender phone profilePicture confirmed fcmToken')
        .populate('medications', 'name type dosage frequency activeIngredient status isChronic endDate')
        .populate('longTermMedication', 'name type dosage frequency activeIngredient status isChronic endDate')
        .lean();
        
    if (!patient) return res.status(404).json({ message: 'Patient not found' });

    // Fetch measurements manually
    patient.measurements = await healthMeasurementModel.find({ patientId: patient._id }).sort({ date: -1 }).lean();

    // Decrypt phone if possible
    if (patient.userId && patient.userId.phone) {
        try { patient.userId.phone = await ET.decrypt(patient.userId.phone); } catch (e) {}
    }

    // Decrypt fcmToken if possible
    if (patient.userId && patient.userId.fcmToken) {
        try { patient.userId.fcmToken = await ET.decrypt(patient.userId.fcmToken); } catch (e) {}
    }

    if (['online', 'card', 'paymob'].includes(booking.paymentMethod) && booking.paymentStatus !== 'paid') {
        return res.status(400).json({ message: 'Cannot start session. Booking is not paid yet.' });
    }

    booking.sessionActive = true;
    // Session window valid for 2 hours
    const expiresAt = new Date();
    expiresAt.setHours(expiresAt.getHours() + 2);
    booking.sessionExpiresAt = expiresAt;
    await booking.save();

    return res.status(200).json({ 
        message: 'Session started successfully. Elevated permissions granted.', 
        bookingId: booking._id, 
        expiresAt,
        patient
    });
};

export const endSession = async (req, res) => {
    const { bookingId } = req.params;
    const userId = req.user.id;

    const booking = await bookingModel.findById(bookingId);
    if (!booking) return res.status(404).json({ message: 'Booking not found' });

    const doc = await doctorModel.findOne({ userId });
    const patient = await patientModel.findOne({ userId });

    if (!doc && !patient) return res.status(403).json({ message: 'Access denied' });
    if (doc && String(booking.doctorId) !== String(doc._id)) return res.status(403).json({ message: 'Access denied' });
    if (patient && String(booking.patientId) !== String(patient._id)) return res.status(403).json({ message: 'Access denied' });

    booking.sessionActive = false;
    booking.sessionToken = undefined;
    booking.sessionExpiresAt = new Date(); // expire immediately
    booking.status = 'completed';
    await booking.save();

    return res.status(200).json({ message: 'Session ended successfully. Elevated permissions revoked.' });
};

export const getCallToken = async (req, res) => {
    const userId = req.user.id;
    const { bookingId } = req.params;

    const booking = await bookingModel.findById(bookingId);
    if (!booking) return res.status(404).json({ message: 'Booking not found' });

    let authorized = false;
    const patient = await patientModel.findOne({ userId });
    if (patient && String(booking.patientId) === String(patient._id)) authorized = true;

    const doc = await doctorModel.findOne({ userId });
    if (doc && String(booking.doctorId) === String(doc._id)) authorized = true;

    if (!authorized) return res.status(403).json({ message: 'Access denied' });

    if (!booking.sessionActive || !booking.sessionExpiresAt || new Date() > booking.sessionExpiresAt) {
        return res.status(403).json({ message: 'Live session is not active or has expired. Cannot start a call.' });
    }

    const roomName = `MediApp-Session-${booking._id}-${booking.doctorId}`;

    return res.status(200).json({ 
        message: 'Token generated',
        roomName
    });
};
