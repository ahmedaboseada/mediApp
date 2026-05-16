// import userModel from '../../models/user.model.js';
// import patientModel from '../../models/patient.model.js';
// import caregiverRequestModel from '../../models/caregiver-request.model.js';
// import * as ET from '../../utils/encryption/index.js';

// const calcDOBAndAge = (yearOfBirth) => {
//     const y = Number(yearOfBirth);
//     const dob = new Date(Date.UTC(y, 0, 1));
//     const now = new Date();
//     const age = now.getUTCFullYear() - y;
//     return { dob, age };
// };

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
//     if (user.type !== 'patient') return res.status(403).json({ message: 'Forbidden' });

//     const patient = await patientModel.findOne({ userId: user._id });
//     if (!patient) return res.status(404).json({ message: 'Patient record missing' });

//     const { phone, yearOfBirth, gender, profilePicture } = req.body;

//     const { dob, age } = calcDOBAndAge(yearOfBirth);

//     user.phone = await ET.encrypt(phone);
//     user.DOB = dob;
//     user.age = age;
//     user.gender = gender;
//     if (profilePicture) user.profilePicture = profilePicture;

//     await user.save();

//     const patch = {};
//     const fields = [
//         'chronicConditions',
//         'allergies',
//         'activeIngredients',
//         'longTermMedication',
//         'bloodTypes',
//         'emergencyContact',
//     ];
//     for (const f of fields) if (req.body[f] !== undefined) patch[f] = req.body[f];

//     if (req.body.caregivingOption !== undefined) {
//         patch['caregiver.caregivingOption'] = !!req.body.caregivingOption;
//     }

//     const updatedPatient = await patientModel.findByIdAndUpdate(patient._id, patch, { new: true }).lean();

//     return res.status(200).json({
//         message: 'Profile completed',
//         user: publicUser(user),
//         patient: updatedPatient,
//     });
// };

// export const requestCaregiver = async (req, res) => {
//     const userId = req.user.id;

//     const patient = await patientModel.findOne({ userId }).lean();
//     if (!patient) return res.status(404).json({ message: 'Patient record missing' });

//     const { caregiverEmail, relationship } = req.body;

//     const caregiverUser = await userModel.findOne({ email: caregiverEmail.toLowerCase().trim() }).lean();
//     if (!caregiverUser) return res.status(404).json({ message: 'Caregiver user not found' });

//     // prevent self-invite
//     if (String(caregiverUser._id) === String(userId)) return res.status(400).json({ message: 'Invalid caregiver' });

//     // one pending request max
//     const exists = await caregiverRequestModel.findOne({
//         patientId: patient._id,
//         caregiverUserId: caregiverUser._id,
//         status: 'pending',
//     }).lean();

//     if (exists) return res.status(400).json({ message: 'Request already pending' });

//     const r = await caregiverRequestModel.create({
//         patientId: patient._id,
//         caregiverUserId: caregiverUser._id,
//         relationship,
//     });

//     return res.status(201).json({
//         message: 'Caregiver request sent',
//         requestId: String(r._id),
//     });
// };

// export const listCaregiverRequests = async (req, res) => {
//     const caregiverUserId = req.user.id;

//     const pending = await caregiverRequestModel
//         .find({ caregiverUserId, status: 'pending' })
//         .populate([{ path: 'patientId', populate: { path: 'userId', select: 'firstName lastName email type gender DOB age profilePicture' } }])
//         .lean();

//     return res.status(200).json({ requests: pending });
// };

// export const acceptCaregiverRequest = async (req, res) => {
//     const caregiverUserId = req.user.id;
//     const { requestId } = req.params;

//     const r = await caregiverRequestModel.findById(requestId);
//     if (!r) return res.status(404).json({ message: 'Request not found' });

//     if (String(r.caregiverUserId) !== String(caregiverUserId)) return res.status(403).json({ message: 'Forbidden' });
//     if (r.status !== 'pending') return res.status(400).json({ message: 'Request already handled' });

//     const patient = await patientModel.findById(r.patientId);
//     if (!patient) return res.status(404).json({ message: 'Patient not found' });

//     // Link on patient side
//     patient.caregiver = patient.caregiver || {};
//     patient.caregiver.taking = caregiverUserId;
//     patient.caregiver.caregivingOption = true;
//     await patient.save();

//     // Link on caregiver side (caregiver.giving list)
//     let caregiverPatient = await patientModel.findOne({ userId: caregiverUserId });
//     if (!caregiverPatient) caregiverPatient = await patientModel.create({ userId: caregiverUserId });

//     caregiverPatient.caregiver = caregiverPatient.caregiver || {};
//     caregiverPatient.caregiver.giving = caregiverPatient.caregiver.giving || [];

//     const pid = String(patient._id);
//     const already = caregiverPatient.caregiver.giving.some((x) => String(x) === pid);
//     if (!already) caregiverPatient.caregiver.giving.push(patient._id);

//     caregiverPatient.caregiver.caregivingOption = true;
//     await caregiverPatient.save();

//     r.status = 'accepted';
//     r.respondedAt = new Date();
//     await r.save();

//     return res.status(200).json({ message: 'Request accepted' });
// };

// export const rejectCaregiverRequest = async (req, res) => {
//     const caregiverUserId = req.user.id;
//     const { requestId } = req.params;

//     const r = await caregiverRequestModel.findById(requestId);
//     if (!r) return res.status(404).json({ message: 'Request not found' });

//     if (String(r.caregiverUserId) !== String(caregiverUserId)) return res.status(403).json({ message: 'Forbidden' });
//     if (r.status !== 'pending') return res.status(400).json({ message: 'Request already handled' });

//     r.status = 'rejected';
//     r.respondedAt = new Date();
//     await r.save();

//     return res.status(200).json({ message: 'Request rejected' });
// };

import userModel from '../../models/user.model.js';
import patientModel from '../../models/patient.model.js';
import caregiverRequestModel from '../../models/caregiver-request.model.js';
import notificationModel from '../../models/notification.model.js';
import medicineModel from '../../models/medicine.model.js';
import doctorModel from '../../models/doctor.model.js';
import { analyzeMedications } from '../../utils/ai.util.js';
import * as ET from '../../utils/encryption/index.js';

const publicUser = async (u) => {
    let decryptedPhone = u.phone;
    if (u.phone) {
        try { decryptedPhone = await ET.decrypt(u.phone); } catch (err) { }
    }
    return {
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
        phone: decryptedPhone,
        yearOfBirth: u.yearOfBirth,
        chronicConditions: u.chronicConditions,
        longTermMedication: u.longTermMedication,
        activeIngredients: u.activeIngredients,
        allergies: u.allergies,
        reactionToMedication: u.reactionToMedication,
        allergyAlerts: u.allergyAlerts,
        measurements: u.measurements,
    };
};

const calcDOBAndAge = (year) => {
    const y = Number(year);
    const dob = new Date(Date.UTC(y, 0, 1));
    const now = new Date();
    const age = now.getUTCFullYear() - y;
    return { dob, age };
};

const formatEgyptianPhoneNumber = (phone) => {
    if (!phone) return phone;
    let cleaned = phone.toString().replace(/[^\d+]/g, '');
    if (cleaned.startsWith('+20') && cleaned.length === 13) return cleaned;
    if (cleaned.startsWith('0020') && cleaned.length === 14) return '+' + cleaned.substring(2);
    if (cleaned.startsWith('20') && cleaned.length === 12) return '+' + cleaned;
    if (cleaned.startsWith('01') && cleaned.length === 11) return '+20' + cleaned.substring(1);
    if (cleaned.startsWith('1') && cleaned.length === 10) return '+20' + cleaned;
    return phone;
};

// Screen: Complete Your Profile (basic)
export const completeBasic = async (req, res) => {
    const userId = req.user.id;

    const user = await userModel.findById(userId);
    if (!user) return res.status(404).json({ message: 'User Not Found' });
    if (user.type !== 'patient') return res.status(403).json({ message: 'Forbidden' });

    const patient = await patientModel.findOne({ userId });
    if (!patient) return res.status(404).json({ message: 'Patient record missing' });

    const { phone, yearOfBirth, gender, profilePicture } = req.body;
    const { dob, age } = calcDOBAndAge(yearOfBirth);

    user.phone = await ET.encrypt(phone);
    user.DOB = dob;
    user.age = age;
    user.gender = gender;

    if (req.files?.avatar?.[0]?.cloudinaryUrl) {
        user.profilePicture = req.files.avatar[0].cloudinaryUrl;
    } else if (profilePicture !== undefined) {
        user.profilePicture = profilePicture;
    }

    await user.save();

    return res.status(200).json({ message: 'Basic profile completed', user: await publicUser(user) });
};

// Screen: health step 1
export const completeHealth1 = async (req, res) => {
    const userId = req.user.id;

    const user = await userModel.findById(userId).lean();
    if (!user) return res.status(404).json({ message: 'User Not Found' });
    if (user.type !== 'patient') return res.status(403).json({ message: 'Forbidden' });

    const patient = await patientModel.findOne({ userId });
    if (!patient) return res.status(404).json({ message: 'Patient record missing' });

    const { chronicConditions, longTermMedication, activeIngredients } = req.body;

    patient.chronicConditions = chronicConditions;

    const resolvedMedicationIds = [];
    if (longTermMedication && longTermMedication.length > 0) {
        for (const medName of longTermMedication) {
            let existingMed = await medicineModel.findOne({ patientId: patient._id, name: { $regex: new RegExp(`^${medName.trim()}$`, 'i') } });
            if (!existingMed) {
                existingMed = await medicineModel.create({
                    patientId: patient._id,
                    name: medName.trim(),
                    type: 'other',
                    frequency: 'daily',
                    daily: ['09:00'],
                    isChronic: true
                });
            }
            resolvedMedicationIds.push(existingMed._id);
            if (!patient.medications.includes(existingMed._id)) {
                patient.medications.push(existingMed._id);
            }
        }
    }

    patient.longTermMedication = resolvedMedicationIds;
    patient.activeIngredients = activeIngredients;

    await patient.save();

    // AI Check in background: Extract active ingredients and check interactions
    if (resolvedMedicationIds && resolvedMedicationIds.length > 0) {
        analyzeMedications(patient._id, resolvedMedicationIds, patient.allergies || []).catch(console.error);
    }

    return res.status(200).json({ message: 'Health step 1 saved', patient: patient.toObject() });
};

// Screen: health step 2
export const completeHealth2 = async (req, res) => {
    const userId = req.user.id;

    const user = await userModel.findById(userId).lean();
    if (!user) return res.status(404).json({ message: 'User Not Found' });
    if (user.type !== 'patient') return res.status(403).json({ message: 'Forbidden' });

    const patient = await patientModel.findOne({ userId });
    if (!patient) return res.status(404).json({ message: 'Patient record missing' });

    const { allergies, reactionToMedication, allergyAlerts } = req.body;

    patient.allergies = allergies;
    patient.reactionToMedication = reactionToMedication;
    patient.allergyAlerts = allergyAlerts;

    await patient.save();

    // AI Check in background if allergies change
    if (patient.longTermMedication && patient.longTermMedication.length > 0) {
        analyzeMedications(patient._id, patient.longTermMedication, patient.allergies || []).catch(console.error);
    }

    return res.status(200).json({ message: 'Health step 2 saved', patient: patient.toObject() });
};

// Screen: caregiver toggle
export const setCaregiverOption = async (req, res) => {
    const userId = req.user.id;

    const patient = await patientModel.findOne({ userId });
    if (!patient) return res.status(404).json({ message: 'Patient record missing' });

    patient.caregiver = patient.caregiver || {};
    patient.caregiver.caregivingOption = !!req.body.caregivingOption;
    await patient.save();

    return res.status(200).json({ message: 'Caregiver option updated' });
};

// Screen: send caregiver invite
export const requestCaregiver = async (req, res) => {
    const userId = req.user.id;

    const patient = await patientModel.findOne({ userId }).lean();
    if (!patient) return res.status(404).json({ message: 'Patient record missing' });

    const { caregiverEmail, relationship } = req.body;

    const caregiverUser = await userModel.findOne({ email: caregiverEmail.toLowerCase().trim() }).lean();
    if (!caregiverUser) return res.status(404).json({ message: 'Caregiver user not found' });
    if (String(caregiverUser._id) === String(userId)) return res.status(400).json({ message: 'Invalid caregiver' });

    const r = await caregiverRequestModel.create({
        patientId: patient._id,
        caregiverUserId: caregiverUser._id,
        relationship,
    });

    return res.status(201).json({ message: 'Invitation sent', requestId: String(r._id) });
};

// Screen: caregiver inbox (on caregiver account)
export const listCaregiverRequests = async (req, res) => {
    const caregiverUserId = req.user.id;

    const requests = await caregiverRequestModel
        .find({ caregiverUserId, status: 'pending' })
        .populate([{ path: 'patientId', populate: { path: 'userId', select: 'firstName lastName email type gender DOB age profilePicture' } }])
        .lean();

    return res.status(200).json({ requests });
};

export const acceptCaregiverRequest = async (req, res) => {
    const caregiverUserId = req.user.id;
    const { requestId } = req.params;

    const r = await caregiverRequestModel.findById(requestId);
    if (!r) return res.status(404).json({ message: 'Request not found' });
    if (String(r.caregiverUserId) !== String(caregiverUserId)) return res.status(403).json({ message: 'Forbidden' });
    if (r.status !== 'pending') return res.status(400).json({ message: 'Request already handled' });

    const patient = await patientModel.findById(r.patientId);
    if (!patient) return res.status(404).json({ message: 'Patient not found' });

    // patient side link
    patient.caregiver = patient.caregiver || {};
    patient.caregiver.taking = caregiverUserId;
    patient.caregiver.caregivingOption = true;
    await patient.save();

    // caregiver side link (ensure caregiver has patient doc)
    let caregiverPatient = await patientModel.findOne({ userId: caregiverUserId });
    if (!caregiverPatient) caregiverPatient = await patientModel.create({ userId: caregiverUserId });

    caregiverPatient.caregiver = caregiverPatient.caregiver || {};
    caregiverPatient.caregiver.giving = caregiverPatient.caregiver.giving || [];
    if (!caregiverPatient.caregiver.giving.some((x) => String(x) === String(patient._id))) {
        caregiverPatient.caregiver.giving.push(patient._id);
    }
    caregiverPatient.caregiver.caregivingOption = true;
    await caregiverPatient.save();

    r.status = 'accepted';
    r.respondedAt = new Date();
    await r.save();

    await notificationModel.create({
        type: 'caregiverRequestAccepted',
        header: 'Caregiver Accepted',
        message: 'Your request for a caregiver has been accepted.',
        userId: patient.userId,
    });

    return res.status(200).json({ message: 'Request accepted' });
};

export const rejectCaregiverRequest = async (req, res) => {
    const caregiverUserId = req.user.id;
    const { requestId } = req.params;

    const r = await caregiverRequestModel.findById(requestId);
    if (!r) return res.status(404).json({ message: 'Request not found' });
    if (String(r.caregiverUserId) !== String(caregiverUserId)) return res.status(403).json({ message: 'Forbidden' });
    if (r.status !== 'pending') return res.status(400).json({ message: 'Request already handled' });

    r.status = 'rejected';
    r.respondedAt = new Date();
    await r.save();

    const patient = await patientModel.findById(r.patientId);
    if (patient) {
        await notificationModel.create({
            type: 'caregiverRequestRejected',
            header: 'Caregiver Rejected',
            message: 'Your request for a caregiver has been rejected.',
            userId: patient.userId,
        });
    }

    return res.status(200).json({ message: 'Request rejected' });
};

export const cancelCaregiverRequest = async (req, res) => {
    const patientUserId = req.user.id;
    const { requestId } = req.params;

    const patient = await patientModel.findOne({ userId: patientUserId });
    if (!patient) return res.status(404).json({ message: 'Patient not found' });

    const r = await caregiverRequestModel.findById(requestId);
    if (!r) return res.status(404).json({ message: 'Request not found' });
    if (String(r.patientId) !== String(patient._id)) return res.status(403).json({ message: 'Forbidden' });
    if (r.status !== 'pending') return res.status(400).json({ message: 'Can only cancel pending requests' });

    r.status = 'cancelled';
    r.respondedAt = new Date();
    await r.save();

    return res.status(200).json({ message: 'Caregiver request cancelled successfully' });
};

export const connectDoctor = async (req, res) => {
    const patientUserId = req.user.id;
    const { doctorId } = req.body;

    const patient = await patientModel.findOne({ userId: patientUserId });
    if (!patient) return res.status(404).json({ message: 'Patient profile not found' });

    const doc = await doctorModel.findById(doctorId);
    if (!doc) return res.status(404).json({ message: 'Doctor not found' });

    const existingPatientConn = patient.connectedDoctors?.find(c => String(c.doctorId) === doctorId);
    if (existingPatientConn) return res.status(400).json({ message: `Connection already ${existingPatientConn.status}` });

    patient.connectedDoctors.push({ doctorId: doc._id, status: 'pending' });
    await patient.save();

    const existingDocConn = doc.connectedPatients?.find(c => String(c.patientId) === String(patient._id));
    if (!existingDocConn) {
        doc.connectedPatients.push({ patientId: patient._id, status: 'pending' });
        await doc.save();
    }

    await notificationModel.create({
        type: 'doctorAdditionRequest',
        header: 'New Patient Request',
        message: 'A patient has requested to connect with you.',
        userId: doc.userId,
    });

    return res.status(200).json({ message: 'Access request sent to doctor' });
};

export const listConnectedDoctors = async (req, res) => {
    const patientUserId = req.user.id;
    const patient = await patientModel.findOne({ userId: patientUserId })
        .populate({
            path: 'connectedDoctors.doctorId',
            populate: { path: 'userId', select: 'firstName lastName profilePicture phone' }
        }).lean();

    if (!patient) return res.status(404).json({ message: 'Patient profile not found' });

    // Only return those approved
    const approved = patient.connectedDoctors.filter(c => c.status === 'approved').map(c => c.doctorId);

    for (const doc of approved) {
        if (doc && doc.userId && doc.userId.phone) {
            try { doc.userId.phone = await ET.decrypt(doc.userId.phone); } catch (err) { }
        }
    }

    return res.status(200).json({ doctors: approved });
};

export const listDoctorRequests = async (req, res) => {
    const patientUserId = req.user.id;
    const patient = await patientModel.findOne({ userId: patientUserId })
        .populate({
            path: 'connectedDoctors.doctorId',
            populate: { path: 'userId', select: 'firstName lastName profilePicture phone' }
        }).lean();

    if (!patient) return res.status(404).json({ message: 'Patient profile not found' });

    // Only return those pending
    const pendingRequests = patient.connectedDoctors
        .filter(c => c.status === 'pending')
        .map(c => c.doctorId);

    for (const doc of pendingRequests) {
        if (doc && doc.userId && doc.userId.phone) {
            try { doc.userId.phone = await ET.decrypt(doc.userId.phone); } catch (err) { }
        }
    }

    return res.status(200).json({ requests: pendingRequests });
};

export const acceptDoctor = async (req, res) => {
    const patientUserId = req.user.id;
    const { doctorId } = req.params;

    const patient = await patientModel.findOne({ userId: patientUserId });
    if (!patient) return res.status(404).json({ message: 'Patient not found' });

    const doc = await doctorModel.findById(doctorId);
    if (!doc) return res.status(404).json({ message: 'Doctor not found' });

    // update patient's side
    let patConn = patient.connectedDoctors?.find(c => String(c.doctorId) === String(doc._id));
    if (!patConn) return res.status(400).json({ message: 'No connection request found' });
    if (patConn.status === 'approved') return res.status(400).json({ message: 'Already approved' });

    patient.connectedDoctors = patient.connectedDoctors.map(c =>
        String(c.doctorId) === String(doc._id) ? { ...c, status: 'approved' } : c
    );
    await patient.save();

    // update doctor's side
    let docConn = doc.connectedPatients?.find(c => String(c.patientId) === String(patient._id));
    if (docConn) {
        doc.connectedPatients = doc.connectedPatients.map(c =>
            String(c.patientId) === String(patient._id) ? { ...c, status: 'approved' } : c
        );
        await doc.save();
    }

    await notificationModel.create({
        type: 'patientRequestAccepted',
        header: 'Patient Request Approved!',
        message: 'A patient has approved your access request.',
        userId: doc.userId,
    });

    return res.status(200).json({ message: 'Doctor approved successfully!' });
};

export const rejectDoctor = async (req, res) => {
    const patientUserId = req.user.id;
    const { doctorId } = req.params;

    const patient = await patientModel.findOne({ userId: patientUserId });
    if (!patient) return res.status(404).json({ message: 'Patient not found' });

    const doc = await doctorModel.findById(doctorId);
    // If doc doesn't exist, we can still remove the request locally
    if (doc) {
        doc.connectedPatients = doc.connectedPatients?.filter(c => String(c.patientId) !== String(patient._id));
        await doc.save();
    }

    patient.connectedDoctors = patient.connectedDoctors?.filter(c => String(c.doctorId) !== String(doctorId));
    await patient.save();

    return res.status(200).json({ message: 'Doctor connection rejected successfully!' });
};

export const cancelDoctorRequest = async (req, res) => {
    const patientUserId = req.user.id;
    const { doctorId } = req.params;

    const patient = await patientModel.findOne({ userId: patientUserId });
    if (!patient) return res.status(404).json({ message: 'Patient not found' });

    const doc = await doctorModel.findById(doctorId);
    
    // Remove from patient's side
    if (patient.connectedDoctors) {
        patient.connectedDoctors = patient.connectedDoctors.filter(c => String(c.doctorId) !== String(doctorId));
        await patient.save();
    }
    
    // Remove from doctor's side
    if (doc && doc.connectedPatients) {
        doc.connectedPatients = doc.connectedPatients.filter(c => String(c.patientId) !== String(patient._id));
        await doc.save();
    }

    return res.status(200).json({ message: 'Doctor connection request cancelled' });
};

export const completeProfile = async (req, res) => {
    const userId = req.user.id;

    const user = await userModel.findById(userId);
    if (!user) return res.status(404).json({ message: 'User Not Found' });
    if (user.type !== 'patient') return res.status(403).json({ message: 'Forbidden' });

    const patient = await patientModel.findOne({ userId: user._id });
    if (!patient) return res.status(404).json({ message: 'Patient record missing' });

    const { phone, yearOfBirth, gender, profilePicture } = req.body;

    const { dob, age } = calcDOBAndAge(yearOfBirth);

    user.phone = await ET.encrypt(phone);
    user.DOB = dob;
    user.age = age;
    user.gender = gender;

    if (req.files?.avatar?.[0]?.cloudinaryUrl) {
        user.profilePicture = req.files.avatar[0].cloudinaryUrl;
    } else if (profilePicture !== undefined) {
        user.profilePicture = profilePicture;
    }

    await user.save();

    const parseArray = (input) => {
        if (!input) return [];
        if (Array.isArray(input)) return input;
        if (typeof input === 'string') {
            try { return JSON.parse(input.replace(/'/g, '"')); } catch (e) { return input.split(',').map(s => s.trim()); }
        }
        return [];
    };

    const patch = {};
    const fields = [
        'chronicConditions',
        'allergies',
        'activeIngredients',
    ];
    for (const f of fields) {
        if (req.body[f] !== undefined) {
            patch[f] = parseArray(req.body[f]);
        }
    }

    if (req.body.bloodTypes !== undefined) patch.bloodTypes = req.body.bloodTypes;
    if (req.body.emergencyContact !== undefined) {
        let ec = req.body.emergencyContact;
        if (typeof ec === 'string') {
            try { ec = JSON.parse(ec); } catch (e) { }
        }
        if (ec && ec.phone) {
            ec.phone = formatEgyptianPhoneNumber(ec.phone);
            
            let userPhoneFormatted = phone ? formatEgyptianPhoneNumber(phone) : null;
            if (!userPhoneFormatted && user.phone) {
                try {
                    userPhoneFormatted = formatEgyptianPhoneNumber(await ET.decrypt(user.phone));
                } catch(e) {}
            }
            if (userPhoneFormatted && userPhoneFormatted === ec.phone) {
                return res.status(400).json({ message: 'Emergency contact cannot be your own phone number' });
            }
        }
        patch.emergencyContact = ec;
    }

    if (req.body.longTermMedication !== undefined) {
        const resolvedMedicationIds = [];
        const medsArray = parseArray(req.body.longTermMedication);
        if (medsArray.length > 0) {
            for (const medName of medsArray) {
                let existingMed = await medicineModel.findOne({ patientId: patient._id, name: { $regex: new RegExp(`^${medName.trim()}$`, 'i') } });
                if (!existingMed) {
                    existingMed = await medicineModel.create({
                        patientId: patient._id,
                        name: medName.trim(),
                        type: 'other',
                        frequency: 'daily',
                        daily: ['09:00'],
                        isChronic: true
                    });
                }
                resolvedMedicationIds.push(existingMed._id);
                if (!patient.medications.includes(existingMed._id)) {
                    patient.medications.push(existingMed._id);
                }
            }
        }
        patch.longTermMedication = resolvedMedicationIds;
        patch.medications = patient.medications;
    }

    if (req.body.caregivingOption !== undefined) {
        patch['caregiver.caregivingOption'] = !!req.body.caregivingOption;
    }

    const updatedPatient = await patientModel.findByIdAndUpdate(patient._id, patch, { new: true }).lean();

    if (patch.longTermMedication && patch.longTermMedication.length > 0) {
        analyzeMedications(updatedPatient._id, patch.longTermMedication, updatedPatient.allergies || []).catch(console.error);
    }

    return res.status(200).json({
        message: 'Profile completed',
        user: await publicUser(user),
        patient: updatedPatient,
    });
};

export const setEmergencyContact = async (req, res) => {
    const userId = req.user.id;
    let { name, phone, contactMethod } = req.body;
    
    phone = formatEgyptianPhoneNumber(phone);

    const user = await userModel.findById(userId);
    if (!user) return res.status(404).json({ message: 'User not found' });
    
    let userPhoneFormatted = null;
    if (user.phone) {
        try {
            userPhoneFormatted = formatEgyptianPhoneNumber(await ET.decrypt(user.phone));
        } catch(e) {}
    }
    
    if (userPhoneFormatted && userPhoneFormatted === phone) {
        return res.status(400).json({ message: 'Emergency contact cannot be your own phone number' });
    }

    const patient = await patientModel.findOne({ userId });
    if (!patient) return res.status(404).json({ message: 'Patient not found' });

    patient.emergencyContact = { name, phone, contactMethod };
    await patient.save();

    return res.status(200).json({ message: 'Emergency contact updated successfully', emergencyContact: patient.emergencyContact });
};

import twilio from 'twilio';

export const triggerSOS = async (req, res) => {
    const userId = req.user.id;
    const { lat, lng } = req.body;

    const user = await userModel.findById(userId);
    const patient = await patientModel.findOne({ userId });
    if (!patient || !patient.emergencyContact || !patient.emergencyContact.phone) {
        return res.status(400).json({ message: 'No emergency contact set up.' });
    }

    const { name, phone, contactMethod } = patient.emergencyContact;

    // Construct message
    const locationLink = (lat && lng) ? `https://maps.google.com/?q=${lat},${lng}` : 'location unavailable';
    const timestamp = new Date().toLocaleTimeString();
    const messageText = `EMERGENCY SOS: This is an automated alert from MediApp. ${user.firstName || 'The patient'} needs immediate help. Live location: ${locationLink} (Sent at: ${timestamp})`;

    let deepLink = '';

    // Clean phone number (remove +, spaces, dashes for wa.me link)
    const cleanPhone = phone.replace(/[^\d]/g, '');

    if (contactMethod === 'whatsapp') {
        deepLink = `https://wa.me/${cleanPhone}?text=${encodeURIComponent(messageText)}`;
    } else {
        // Fallback to SMS
        deepLink = `sms:${phone}?body=${encodeURIComponent(messageText)}`;
    }

    // Twilio Integration
    const accountSid = process.env.TWILIO_ACCOUNT_SID || 'AC51aa059827f457d17106c28df37a27b7';
    const authToken = process.env.TWILIO_AUTH_TOKEN || '81f095bd735d9b6910998a0a34e896c4';
    const twilioPhone = process.env.TWILIO_PHONE_NUMBER || '+12566459112';

    let twilioStatus = 'sent';
    let twilioError = null;

    try {
        const client = twilio(accountSid, authToken);

        if (contactMethod === 'call') {
            await client.calls.create({
                twiml: `<Response><Say voice="alice">Emergency SOS from MediApp. ${user.firstName || 'The patient'} needs immediate help.</Say></Response>`,
                to: phone,
                from: twilioPhone
            });
        } else if (contactMethod === 'whatsapp') {
            await client.messages.create({
                body: messageText,
                from: `whatsapp:${twilioPhone}`,
                to: `whatsapp:${phone}`
            });
        } else {
            // Default to SMS
            await client.messages.create({
                body: messageText,
                from: twilioPhone,
                to: phone
            });
        }
        console.log(`SOS sent to ${phone} via Twilio`);
    } catch (error) {
        console.error('Twilio Error:', error);
        twilioStatus = 'failed';
        twilioError = error.message;
    }

    return res.status(200).json({ 
        message: 'SOS trigger processed', 
        deepLink,
        twilioStatus,
        twilioError
    });
};