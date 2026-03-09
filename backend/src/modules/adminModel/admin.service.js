import doctorModel from '../../models/doctor.model.js';

export const getPendingDoctors = async (req, res) => {
    try {
        const doctors = await doctorModel
            .find({ status: 'pending' })
            .select('-licenseImage') // do not leak encrypted image immediately unless requested
            .populate('userId', 'firstName lastName email profilePicture phone gender')
            .lean();

        return res.status(200).json({ message: 'Pending doctors retrieved successfully', data: doctors });
    } catch (err) {
        return res.status(500).json({ message: 'Internal server error', error: err.message });
    }
};

export const approveDoctor = async (req, res) => {
    try {
        const doctor = await doctorModel.findByIdAndUpdate(
            req.params.id,
            { status: 'approved' },
            { new: true }
        );

        if (!doctor) return res.status(404).json({ message: 'Doctor not found' });

        return res.status(200).json({ message: 'Doctor approved successfully', doctor });
    } catch (err) {
        return res.status(500).json({ message: 'Internal server error', error: err.message });
    }
};

export const rejectDoctor = async (req, res) => {
    try {
        const doctor = await doctorModel.findByIdAndUpdate(
            req.params.id,
            { status: 'rejected' },
            { new: true }
        );

        if (!doctor) return res.status(404).json({ message: 'Doctor not found' });

        return res.status(200).json({ message: 'Doctor rejected successfully', doctor });
    } catch (err) {
        return res.status(500).json({ message: 'Internal server error', error: err.message });
    }
};
