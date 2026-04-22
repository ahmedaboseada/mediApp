import * as bookingService from './booking.service.js';

export const getDoctorSlots = async (req, res, next) => {
    try {
        await bookingService.getDoctorSlots(req, res);
    } catch (err) {
        next(err);
    }
};

export const createBooking = async (req, res, next) => {
    try {
        await bookingService.createBooking(req, res);
    } catch (err) {
        next(err);
    }
};

export const getMyBookingsAsPatient = async (req, res, next) => {
    try {
        await bookingService.getMyBookingsAsPatient(req, res);
    } catch (err) {
        next(err);
    }
};

export const getMyBookingsAsDoctor = async (req, res, next) => {
    try {
        await bookingService.getMyBookingsAsDoctor(req, res);
    } catch (err) {
        next(err);
    }
};

export const cancelBooking = async (req, res, next) => {
    try {
        await bookingService.cancelBooking(req, res);
    } catch (err) {
        next(err);
    }
};

export const rescheduleBooking = async (req, res, next) => {
    try {
        await bookingService.rescheduleBooking(req, res);
    } catch (err) {
        next(err);
    }
};

export const getBookingDetails = async (req, res, next) => {
    try {
        await bookingService.getBookingDetails(req, res);
    } catch (err) {
        next(err);
    }
};
