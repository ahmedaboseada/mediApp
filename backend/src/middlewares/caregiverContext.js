import patientModel from '../models/patient.model.js';

export const applyCaregiverContext = async (req, res, next) => {
    const targetUserId = req.headers['x-patient-user-id'];
    
    if (targetUserId) {
        if (!req.user || !req.user.id) {
            return res.status(401).json({ message: 'Unauthorized' });
        }

        try {
            const targetPatient = await patientModel.findOne({ userId: targetUserId }).lean();
            if (!targetPatient) {
                return res.status(404).json({ message: 'Target patient not found' });
            }

            // Check if current user is the authorized caregiver
            if (
                targetPatient.caregiver &&
                String(targetPatient.caregiver.taking) === String(req.user.id) &&
                targetPatient.caregiver.caregivingOption
            ) {
                // Keep the original user id just in case
                req.user.caregiverOriginalId = req.user.id;
                // Override the id to act on behalf of the patient
                req.user.id = targetUserId;
            } else {
                return res.status(403).json({ message: 'Forbidden: You are not an authorized caregiver for this patient' });
            }
        } catch (error) {
            console.error("applyCaregiverContext Error:", error);
            return res.status(500).json({ message: 'Internal Server Error' });
        }
    }
    next();
};
