import messageModel from '../../models/message.model.js';

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
