import express from 'express';
import * as bookingController from './booking.controller.js';
import * as validationSchemas from './booking.validation.js';
import { validation } from '../../middlewares/validation.js';
import { verifyToken } from '../../middlewares/authentication.js';
import { restrictTo } from '../../middlewares/restrictTo.js';

const router = express.Router();

router.get('/slots/:doctorId', validation(validationSchemas.getSlotsSchema), bookingController.getDoctorSlots);

router.post('/', verifyToken, restrictTo(['patient']), validation(validationSchemas.createBookingSchema), bookingController.createBooking);

router.get('/patient', verifyToken, restrictTo(['patient']), bookingController.getMyBookingsAsPatient);
router.get('/doctor', verifyToken, restrictTo(['doctor']), bookingController.getMyBookingsAsDoctor);
router.get('/:id', verifyToken, restrictTo(['patient', 'doctor']), validation(validationSchemas.getBookingIdSchema), bookingController.getBookingDetails);

router.patch('/:id/cancel', verifyToken, restrictTo(['patient', 'doctor']), validation(validationSchemas.cancelBookingSchema), bookingController.cancelBooking);
router.patch('/:id/reschedule', verifyToken, restrictTo(['patient']), validation(validationSchemas.rescheduleBookingSchema), bookingController.rescheduleBooking);

export default router;
