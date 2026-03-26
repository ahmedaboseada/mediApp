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
import { analyzeMedications } from '../../utils/ai.util.js';
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

const calcDOBAndAge = (year) => {
    const y = Number(year);
    const dob = new Date(Date.UTC(y, 0, 1));
    const now = new Date();
    const age = now.getUTCFullYear() - y;
    return { dob, age };
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

    return res.status(200).json({ message: 'Basic profile completed', user: publicUser(user) });
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
    if (longTermMedication && longTermMedication.length > 0) {
        analyzeMedications(patient._id, longTermMedication, patient.allergies || []).catch(console.error);
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

    const patch = {};
    const fields = [
        'chronicConditions',
        'allergies',
        'activeIngredients',
        'bloodTypes',
        'emergencyContact',
    ];
    for (const f of fields) if (req.body[f] !== undefined) patch[f] = req.body[f];

    if (req.body.longTermMedication !== undefined) {
        const resolvedMedicationIds = [];
        if (req.body.longTermMedication.length > 0) {
            for (const medName of req.body.longTermMedication) {
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
        user: publicUser(user),
        patient: updatedPatient,
    });
};