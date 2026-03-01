// import doctorModel from '../../models/doctor.model.js';
// import userModel from '../../models/user.model.js';
// import * as ET from '../../utils/encryption/index.js';

// const publicUser = (u) => ({
//     id: String(u._id),
//     type: u.type,
//     firstName: u.firstName,
//     lastName: u.lastName,
//     email: u.email,
//     DOB: u.DOB,
//     age: u.age,
//     gender: u.gender,
//     twoFA: u.twoFA,
//     profilePicture: u.profilePicture,
//     confirmed: u.confirmed,
// });

// export const completeProfile = async (req, res) => {
//     const userId = req.user.id;

//     const user = await userModel.findById(userId);
//     if (!user) return res.status(404).json({ message: 'User Not Found' });
//     if (user.type !== 'doctor') return res.status(403).json({ message: 'Forbidden' });

//     const doc = await doctorModel.findOne({ userId });
//     if (!doc) return res.status(404).json({ message: 'Doctor record missing' });

//     // ---- update USER fields if provided ----
//     const userPatch = {};
//     if (req.body.phone) userPatch.phone = await ET.encrypt(req.body.phone);
//     if (req.body.gender) userPatch.gender = req.body.gender;
//     if (req.body.profilePicture) userPatch.profilePicture = req.body.profilePicture;

//     if (Object.keys(userPatch).length) {
//         await userModel.updateOne({ _id: userId }, userPatch);
//     }

//     // ---- update DOCTOR fields ----
//     const doctorPatch = { ...req.body };

//     // remove user fields from doctorPatch
//     delete doctorPatch.phone;
//     delete doctorPatch.gender;
//     delete doctorPatch.profilePicture;

//     if (doctorPatch.licenseImage) {
//         doctorPatch.licenseImage = await ET.encrypt(doctorPatch.licenseImage);
//     }

//     // normalize: if clinicLocation.label exists but clinicAddress empty -> fill clinicAddress
//     if (doctorPatch.clinicLocation?.label && !doctorPatch.clinicAddress) {
//         doctorPatch.clinicAddress = doctorPatch.clinicLocation.label;
//     }

//     const updatedDoctor = await doctorModel.findByIdAndUpdate(doc._id, doctorPatch, { new: true }).lean();
//     const updatedUser = await userModel.findById(userId).lean();

//     return res.status(200).json({
//         message: 'Doctor profile updated',
//         user: publicUser(updatedUser),
//         doctor: updatedDoctor,
//     });
// };


import doctorModel from '../../models/doctor.model.js';
import userModel from '../../models/user.model.js';
import * as ET from '../../utils/encryption/index.js';

const publicUser = (u) => ({
    id: String(u._id),
    type: u.type,
    firstName: u.firstName,
    lastName: u.lastName,
    email: u.email,
    DOB: u.DOB,
    age: u.age,
    gender: u.gender,
    twoFA: u.twoFA,
    profilePicture: u.profilePicture,
    confirmed: u.confirmed,
});

const assertDoctor = async (userId) => {
    const user = await userModel.findById(userId);
    if (!user) return { err: { status: 404, message: 'User Not Found' } };
    if (user.type !== 'doctor') return { err: { status: 403, message: 'Forbidden' } };
    const doc = await doctorModel.findOne({ userId });
    if (!doc) return { err: { status: 404, message: 'Doctor record missing' } };
    return { user, doc };
};

// Screen: step1
export const completeStep1 = async (req, res) => {
    const userId = req.user.id;
    const { err, user, doc } = await assertDoctor(userId);
    if (err) return res.status(err.status).json({ message: err.message });

    // user fields from screen
    user.phone = await ET.encrypt(req.body.phone);
    user.gender = req.body.gender;
    if (req.body.profilePicture !== undefined) user.profilePicture = req.body.profilePicture;
    await user.save();

    // doctor fields from screen
    doc.specialization = req.body.specialization;
    doc.clinicName = req.body.clinicName;
    doc.medicalLicenseId = req.body.medicalLicenseId;
    await doc.save();

    return res.status(200).json({ message: 'Step 1 saved', user: publicUser(user), doctor: doc.toObject() });
};

// Screen: location
export const completeLocation = async (req, res) => {
    const userId = req.user.id;
    const { err, doc } = await assertDoctor(userId);
    if (err) return res.status(err.status).json({ message: err.message });

    doc.clinicAddress = req.body.clinicAddress;
    if (req.body.clinicLocation) doc.clinicLocation = req.body.clinicLocation;
    await doc.save();

    return res.status(200).json({ message: 'Location saved', doctor: doc.toObject() });
};

// Screen: working days/hours + duration
export const completeSchedule = async (req, res) => {
    const userId = req.user.id;
    const { err, doc } = await assertDoctor(userId);
    if (err) return res.status(err.status).json({ message: err.message });

    doc.workingDays = req.body.workingDays;
    doc.workingHours = req.body.workingHours;
    doc.consultationDuration = req.body.consultationDuration;
    await doc.save();

    return res.status(200).json({ message: 'Schedule saved', doctor: doc.toObject() });
};

// Screen: appointment type + max/day
export const completeAppointments = async (req, res) => {
    const userId = req.user.id;
    const { err, doc } = await assertDoctor(userId);
    if (err) return res.status(err.status).json({ message: err.message });

    doc.appointmentTypes = req.body.appointmentTypes;
    doc.maxDailyPatients = req.body.maxDailyPatients;
    await doc.save();

    return res.status(200).json({ message: 'Appointments saved', doctor: doc.toObject() });
};

// Screen: license image
export const completeLicense = async (req, res) => {
    const userId = req.user.id;
    const { err, doc } = await assertDoctor(userId);
    if (err) return res.status(err.status).json({ message: err.message });

    doc.licenseImage = await ET.encrypt(req.body.licenseImage);
    await doc.save();

    return res.status(200).json({ message: 'License saved' });
};

export const completeProfile = async (req, res) => {
    const userId = req.user.id;

    const user = await userModel.findById(userId);
    if (!user) return res.status(404).json({ message: 'User Not Found' });
    if (user.type !== 'doctor') return res.status(403).json({ message: 'Forbidden' });

    const doc = await doctorModel.findOne({ userId });
    if (!doc) return res.status(404).json({ message: 'Doctor record missing' });

    // ---- update USER fields if provided ----
    const userPatch = {};
    if (req.body.phone) userPatch.phone = await ET.encrypt(req.body.phone);
    if (req.body.gender) userPatch.gender = req.body.gender;
    if (req.body.profilePicture) userPatch.profilePicture = req.body.profilePicture;

    if (Object.keys(userPatch).length) {
        await userModel.updateOne({ _id: userId }, userPatch);
    }

    // ---- update DOCTOR fields ----
    const doctorPatch = { ...req.body };

    // remove user fields from doctorPatch
    delete doctorPatch.phone;
    delete doctorPatch.gender;
    delete doctorPatch.profilePicture;

    if (doctorPatch.licenseImage) {
        doctorPatch.licenseImage = await ET.encrypt(doctorPatch.licenseImage);
    }

    // normalize: if clinicLocation.label exists but clinicAddress empty -> fill clinicAddress
    if (doctorPatch.clinicLocation?.label && !doctorPatch.clinicAddress) {
        doctorPatch.clinicAddress = doctorPatch.clinicLocation.label;
    }

    const updatedDoctor = await doctorModel.findByIdAndUpdate(doc._id, doctorPatch, { new: true }).lean();
    const updatedUser = await userModel.findById(userId).lean();

    return res.status(200).json({
        message: 'Doctor profile updated',
        user: publicUser(updatedUser),
        doctor: updatedDoctor,
    });
};