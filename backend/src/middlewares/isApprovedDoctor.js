import userModel from '../models/user.model.js';
import doctorModel from '../models/doctor.model.js';

export const isApprovedDoctor = async (req, res, next) => {
    try {
        const userId = req.user.id;
        const user = await userModel.findById(userId);

        if (!user) return res.status(404).json({ message: 'User not found' });

        // Normal users, patients, and admins bypass this restriction logic
        if (user.type !== 'doctor') return next();

        if (!user.confirmed) {
            return res.status(403).json({ message: 'Access denied: Please verify your email first.' });
        }

        const doctor = await doctorModel.findOne({ userId });
        if (!doctor) return res.status(404).json({ message: 'Doctor profile not found' });

        if (doctor.status !== 'approved') {
            return res.status(403).json({ message: `Access denied: Your account is currently ${doctor.status} and awaiting admin approval.` });
        }

        next();
    } catch (err) {
        next(err);
    }
};
