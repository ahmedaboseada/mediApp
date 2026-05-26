import reviewModel from '../../models/review.model.js';
import patientModel from '../../models/patient.model.js';
import doctorModel from '../../models/doctor.model.js';
import bookingModel from '../../models/booking.model.js';

export const createReview = async (req, res) => {
    try {
        const { doctorId, rating } = req.body;
        const patient = await patientModel.findOne({ userId: req.user.id });
        if (!patient) {
            return res.status(404).json({ message: 'Patient profile not found' });
        }

        const doctor = await doctorModel.findById(doctorId);
        if (!doctor) {
            return res.status(404).json({ message: 'Doctor not found' });
        }

        // Check if there is an ended/completed booking between them
        const booking = await bookingModel.findOne({
            patientId: patient._id,
            doctorId,
            status: 'completed'
        });

        if (!booking) {
            return res.status(400).json({ message: 'Cannot review this doctor without an ended session' });
        }

        // Check if they already reviewed this doctor
        const existingReview = await reviewModel.findOne({ doctorId, PatientId: patient._id });
        if (existingReview) {
            return res.status(400).json({ message: 'You have already reviewed this doctor' });
        }

        const review = await reviewModel.create({
            doctorId,
            PatientId: patient._id,
            rating,
        });

        return res.status(201).json({ message: 'Review submitted successfully', review });
    } catch (err) {
        console.error(err);
        return res.status(500).json({ message: 'Internal server error' });
    }
};

export const getDoctorReviews = async (req, res) => {
    try {
        const { doctorId } = req.params;
        const reviews = await reviewModel.find({ doctorId })
            .populate({ path: 'PatientId', populate: { path: 'userId', select: 'firstName lastName profilePicture' } })
            .lean();
        return res.status(200).json({ reviews });
    } catch (err) {
        console.error(err);
        return res.status(500).json({ message: 'Internal server error' });
    }
};

export const getMeReviews = async (req, res) => {
    try {
        const patient = await patientModel.findOne({ userId: req.user.id });
        if (!patient) {
            return res.status(404).json({ message: 'Patient profile not found' });
        }

        const reviews = await reviewModel.find({ PatientId: patient._id })
            .populate({ path: 'doctorId', populate: { path: 'userId', select: 'firstName lastName profilePicture' } })
            .lean();
        return res.status(200).json({ reviews });
    } catch (err) {
        console.error(err);
        return res.status(500).json({ message: 'Internal server error' });
    }
};

export const getReviewDetails = async (req, res) => {
    try {
        const { id } = req.params;
        const review = await reviewModel.findById(id)
            .populate({ path: 'doctorId', populate: { path: 'userId', select: 'firstName lastName profilePicture' } })
            .populate({ path: 'PatientId', populate: { path: 'userId', select: 'firstName lastName profilePicture' } })
            .lean();
        if (!review) {
            return res.status(404).json({ message: 'Review not found' });
        }
        return res.status(200).json({ review });
    } catch (err) {
        console.error(err);
        return res.status(500).json({ message: 'Internal server error' });
    }
};

export const updateReview = async (req, res) => {
    try {
        const { id } = req.params;
        const { rating } = req.body;

        const patient = await patientModel.findOne({ userId: req.user.id });
        if (!patient) {
            return res.status(404).json({ message: 'Patient profile not found' });
        }

        const review = await reviewModel.findById(id);
        if (!review) {
            return res.status(404).json({ message: 'Review not found' });
        }

        // Verify ownership
        if (String(review.PatientId) !== String(patient._id)) {
            return res.status(403).json({ message: 'Access denied. You cannot update someone else\'s review' });
        }

        review.rating = rating;
        await review.save();

        return res.status(200).json({ message: 'Review updated successfully', review });
    } catch (err) {
        console.error(err);
        return res.status(500).json({ message: 'Internal server error' });
    }
};

export const deleteReview = async (req, res) => {
    try {
        const { id } = req.params;

        const review = await reviewModel.findById(id);
        if (!review) {
            return res.status(404).json({ message: 'Review not found' });
        }

        // Admins can delete any review, patients can delete their own
        if (req.user.type !== 'admin') {
            const patient = await patientModel.findOne({ userId: req.user.id });
            if (!patient || String(review.PatientId) !== String(patient._id)) {
                return res.status(403).json({ message: 'Access denied. You cannot delete this review' });
            }
        }

        await review.deleteOne();
        return res.status(200).json({ message: 'Review deleted successfully' });
    } catch (err) {
        console.error(err);
        return res.status(500).json({ message: 'Internal server error' });
    }
};
