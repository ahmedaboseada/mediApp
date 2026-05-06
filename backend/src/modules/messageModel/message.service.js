import messageModel from '../../models/message.model.js';
import userModel from '../../models/user.model.js';
import patientModel from '../../models/patient.model.js';
import doctorModel from '../../models/doctor.model.js';

export const send = async (req, res) => {
    const senderId = req.user.id;

    const m = await messageModel.create({
        senderId,
        receiverId: req.body.receiverId,
        message: req.body.message,
        time: new Date(),
        status: 'unseen',
        files: req.body.files || [],
        voiceNote: req.body.voiceNote,
    });

    return res.status(201).json({ message: 'Message sent', data: { id: String(m._id) } });
};

export const verifyChat = async (req, res) => {
    const userId = req.user.id;
    const { targetUserId } = req.params;

    if (userId === targetUserId) {
        return res.status(400).json({ message: 'Cannot chat with yourself' });
    }

    const targetUser = await userModel.findById(targetUserId);
    if (!targetUser) {
        return res.status(404).json({ message: 'Target user not found' });
    }

    let allowed = false;

    const patientA = await patientModel.findOne({ userId });
    const doctorA = await doctorModel.findOne({ userId });

    const patientB = await patientModel.findOne({ userId: targetUserId });
    const doctorB = await doctorModel.findOne({ userId: targetUserId });

    // Scenario 1: User A is Doctor, User B is Patient
    if (doctorA && patientB) {
        const conn = doctorA.connectedPatients?.find(c => String(c.patientId) === String(patientB._id) && c.status === 'approved');
        if (conn) allowed = true;
    }

    // Scenario 2: User A is Patient, User B is Doctor
    if (patientA && doctorB) {
        const conn = doctorB.connectedPatients?.find(c => String(c.patientId) === String(patientA._id) && c.status === 'approved');
        if (conn) allowed = true;
    }

    // Scenario 3: Caregiver (if applicable)
    if (patientA && patientB) {
        const isACaregiverOfB = patientA.caregiver?.giving?.some(id => String(id) === String(patientB._id));
        const isBCaregiverOfA = patientB.caregiver?.giving?.some(id => String(id) === String(patientA._id));
        if (isACaregiverOfB || isBCaregiverOfA) allowed = true;
    }

    if (!allowed) {
        return res.status(403).json({ message: 'You are not authorized to chat with this user' });
    }

    // Create a composite Room ID (lexicographical sort of user IDs)
    const roomId = [userId, targetUserId].sort().join('_');

    return res.status(200).json({
        message: 'Chat allowed',
        roomId,
        targetUser: {
            id: targetUser._id,
            firstName: targetUser.firstName,
            lastName: targetUser.lastName,
            profilePicture: targetUser.profilePicture,
            type: targetUser.type
        }
    });
};
