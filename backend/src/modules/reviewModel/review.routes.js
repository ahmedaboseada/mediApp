import { Router } from 'express';
import * as reviewController from './review.controller.js';
import * as reviewSchemas from './review.validation.js';
import { validation } from '../../middlewares/validation.js';
import { verifyToken } from '../../middlewares/authentication.js';
import { restrictTo } from '../../middlewares/restrictTo.js';

const router = Router();

// Create review (Patient only)
router.post('/', verifyToken, restrictTo(['patient']), validation(reviewSchemas.createReviewSchema), reviewController.createReview);

// Get my reviews (Patient only)
router.get('/me', verifyToken, restrictTo(['patient']), reviewController.getMeReviews);

// Get reviews of a specific doctor (Public)
router.get('/doctor/:doctorId', validation(reviewSchemas.getDoctorReviewsSchema), reviewController.getDoctorReviews);

// Get review details (Public)
router.get('/:id', validation(reviewSchemas.getReviewSchema), reviewController.getReviewDetails);

// Update review (Patient only)
router.patch('/:id', verifyToken, restrictTo(['patient']), validation(reviewSchemas.updateReviewSchema), reviewController.updateReview);

// Delete review (Patient or Admin)
router.delete('/:id', verifyToken, restrictTo(['patient', 'admin']), validation(reviewSchemas.getReviewSchema), reviewController.deleteReview);

export default router;
