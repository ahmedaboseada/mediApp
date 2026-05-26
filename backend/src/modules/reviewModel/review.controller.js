import * as reviewService from './review.service.js';

export const createReview = async (req, res, next) => {
    try {
        await reviewService.createReview(req, res);
    } catch (err) {
        next(err);
    }
};

export const getDoctorReviews = async (req, res, next) => {
    try {
        await reviewService.getDoctorReviews(req, res);
    } catch (err) {
        next(err);
    }
};

export const getMeReviews = async (req, res, next) => {
    try {
        await reviewService.getMeReviews(req, res);
    } catch (err) {
        next(err);
    }
};

export const getReviewDetails = async (req, res, next) => {
    try {
        await reviewService.getReviewDetails(req, res);
    } catch (err) {
        next(err);
    }
};

export const updateReview = async (req, res, next) => {
    try {
        await reviewService.updateReview(req, res);
    } catch (err) {
        next(err);
    }
};

export const deleteReview = async (req, res, next) => {
    try {
        await reviewService.deleteReview(req, res);
    } catch (err) {
        next(err);
    }
};
