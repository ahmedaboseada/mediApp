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
import patientModel from '../../models/patient.model.js';
import notificationModel from '../../models/notification.model.js';
import medicineModel from '../../models/medicine.model.js';
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
    pendingEmail: u.pendingEmail,
    pendingEmailRequestedAt: u.pendingEmailRequestedAt,
    emailChangeTokenId: u.emailChangeTokenId,
    phone: u.phone,
    yearOfBirth: u.yearOfBirth,
    chronicConditions: u.chronicConditions,
    longTermMedication: u.longTermMedication,
    activeIngredients: u.activeIngredients,
    allergies: u.allergies,
    reactionToMedication: u.reactionToMedication,
    allergyAlerts: u.allergyAlerts,
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

    if (req.files?.avatar?.[0]?.cloudinaryUrl) {
        user.profilePicture = req.files.avatar[0].cloudinaryUrl;
    } else if (req.body.profilePicture !== undefined) {
        user.profilePicture = req.body.profilePicture;
    }

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

    let licenseImage = req.files?.licenseImage?.[0]?.cloudinaryUrl || req.body.licenseImage;
    if (!licenseImage) {
        return res.status(400).json({ message: 'License image is required' });
    }

    doc.licenseImage = await ET.encrypt(licenseImage);
    doc.status = 'pending';
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

    if (req.files?.avatar?.[0]?.cloudinaryUrl) {
        userPatch.profilePicture = req.files.avatar[0].cloudinaryUrl;
    } else if (req.body.profilePicture !== undefined) {
        userPatch.profilePicture = req.body.profilePicture;
    }

    if (Object.keys(userPatch).length) {
        await userModel.updateOne({ _id: userId }, userPatch);
    }

    // ---- update DOCTOR fields ----
    const doctorPatch = { ...req.body };

    // remove user fields from doctorPatch
    delete doctorPatch.phone;
    delete doctorPatch.gender;
    delete doctorPatch.profilePicture;

    let licenseImage = req.files?.licenseImage?.[0]?.cloudinaryUrl || doctorPatch.licenseImage;
    if (licenseImage) {
        doctorPatch.licenseImage = await ET.encrypt(licenseImage);
        doctorPatch.status = 'pending';
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

export const updateSchedule = async (req, res) => {
    const userId = req.user.id;
    const { err, doc } = await assertDoctor(userId);
    if (err) return res.status(err.status).json({ message: err.message });

    // Normalize UI choice "Clinic Visit" into backend internal 'in-person'
    const patch = { ...req.body };
    if (patch.appointmentTypes) {
        patch.appointmentTypes = patch.appointmentTypes.map(type =>
            type === 'Clinic Visit' ? 'in-person' : type
        );
    }

    const updatedDoc = await doctorModel.findByIdAndUpdate(doc._id, patch, { new: true }).lean();
    return res.status(200).json({ message: 'Schedule & Availability saved', doctor: updatedDoc });
};

export const getDoctorDirectory = async (req, res) => {
    // patient accesses this to browse all doctors
    const doctors = await doctorModel.find({ status: 'approved' })
        .populate({ path: 'userId', select: 'firstName lastName profilePicture phone gender' })
        .lean();

    return res.status(200).json({ doctors });
};

export const connectPatient = async (req, res) => {
    const doctorUserId = req.user.id;
    const { patientId } = req.body;

    const { err, doc } = await assertDoctor(doctorUserId);
    if (err) return res.status(err.status).json({ message: err.message });

    const patient = await patientModel.findById(patientId);
    if (!patient) return res.status(404).json({ message: 'Patient not found' });

    const existingDocConn = doc.connectedPatients?.find(c => String(c.patientId) === patientId);
    if (existingDocConn) return res.status(400).json({ message: `Connection already ${existingDocConn.status}` });

    doc.connectedPatients.push({ patientId: patient._id, status: 'pending' });
    await doc.save();

    const existingPatientConn = patient.connectedDoctors?.find(c => String(c.doctorId) === String(doc._id));
    if (!existingPatientConn) {
        patient.connectedDoctors.push({ doctorId: doc._id, status: 'pending' });
        await patient.save();
    }

    await notificationModel.create({
        type: 'patientAdditionRequest',
        header: 'New Doctor Request',
        message: 'A doctor has requested to connect with you.',
        userId: patient.userId,
    });

    return res.status(200).json({ message: 'Access request sent to patient' });
};

export const acceptPatient = async (req, res) => {
    const userId = req.user.id;
    const { patientId } = req.params;

    const { err, doc } = await assertDoctor(userId);
    if (err) return res.status(err.status).json({ message: err.message });

    const patient = await patientModel.findById(patientId);
    if (!patient) return res.status(404).json({ message: 'Patient not found' });

    // update doctor's side
    let docConn = doc.connectedPatients?.find(c => String(c.patientId) === String(patient._id));
    if (!docConn) {
        return res.status(400).json({ message: 'No pending request found from this patient' });
    }
    if (docConn.status === 'approved') {
        return res.status(400).json({ message: 'Patient is already approved' });
    }

    // Using doc object from db not lean: assertDoctor returned `doc` which is a mongoose doc
    doc.connectedPatients = doc.connectedPatients.map(c =>
        String(c.patientId) === String(patient._id) ? { ...c, status: 'approved' } : c
    );
    await doc.save();

    // update patient's side
    let patConn = patient.connectedDoctors?.find(c => String(c.doctorId) === String(doc._id));
    if (patConn) {
        patient.connectedDoctors = patient.connectedDoctors.map(c =>
            String(c.doctorId) === String(doc._id) ? { ...c, status: 'approved' } : c
        );
        await patient.save();
    }

    await notificationModel.create({
        type: 'doctorRequestAccepted',
        header: 'Request Approved!',
        message: 'Your doctor request has been approved.',
        userId: patient.userId,
    });

    return res.status(200).json({ message: 'Patient approved successfully!' });
};

export const rejectPatient = async (req, res) => {
    const userId = req.user.id;
    const { patientId } = req.params;

    const { err, doc } = await assertDoctor(userId);
    if (err) return res.status(err.status).json({ message: err.message });

    const patient = await patientModel.findById(patientId);
    if (!patient) return res.status(404).json({ message: 'Patient not found' });

    // remove from doctor's pending list completely
    doc.connectedPatients = doc.connectedPatients.filter(c => String(c.patientId) !== String(patient._id));
    await doc.save();

    // remove from patient's pending list
    if (patient.connectedDoctors) {
        patient.connectedDoctors = patient.connectedDoctors.filter(c => String(c.doctorId) !== String(doc._id));
        await patient.save();
    }

    return res.status(200).json({ message: 'Patient request rejected successfully!' });
};

export const listConnectedPatients = async (req, res) => {
    const userId = req.user.id;
    const { err, doc } = await assertDoctor(userId);
    if (err) return res.status(err.status).json({ message: err.message });

    // Extract approved patient ids
    const approvedPatientIds = doc.connectedPatients?.filter(c => c.status === 'approved').map(c => c.patientId) || [];

    if (approvedPatientIds.length === 0) {
        return res.status(200).json({ patients: [] });
    }

    // Populate patient info deeply
    const patients = await patientModel.find({ _id: { $in: approvedPatientIds } })
        .populate({ path: 'userId', select: 'firstName lastName profilePicture phone age gender' })
        .populate({ path: 'medications', select: 'status isChronic' })
        .lean();

    // Compute UI health Badge mapping
    const enrichedPatients = patients.map(p => {
        let healthBadge = 'Normal Status';

        // Priority 1: Check for critical mode medications
        const hasCriticalMeds = p.medications?.some(m => m.status === 'critical');
        if (hasCriticalMeds) {
            healthBadge = 'Critical';
        } else if (p.healthMeasurements?.sys || p.healthMeasurements?.glucose) {
            // simplified pseudo-abnormal check for demonstration
            healthBadge = 'Abnormal';
        }

        return {
            ...p,
            healthBadge
        };
    });

    return res.status(200).json({ patients: enrichedPatients });
};