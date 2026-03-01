// import userModel from '../../models/user.model.js';
// import { revokeTokenModel } from '../../models/revoke-token.model.js';

// import * as HT from '../../utils/hash/index.js';
// import * as ET from '../../utils/encryption/index.js';
// import * as VT from '../../utils/token/index.js';
// import { otp6 } from '../../utils/index.js';
// import { nanoid } from 'nanoid';

// import { eventEmitter } from '../../utils/sendEmail-events/index.js';

// import patientModel from '../../models/patient.model.js';
// import doctorModel from '../../models/doctor.model.js';

// // helper: do NOT infer admin from doctor unless you intentionally want that
// const isAdminPrefix = (user) => user?.type === 'doctor';

// // helper: never leak password/otp
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

// // =========================
// // UPDATED signup
// // =========================
// export const signup = async (req, res) => {
//     const {
//         firstName,
//         lastName,
//         email,
//         password,
//         phone,
//         type,
//         DOB,
//         age,
//         gender,
//         twoFA,
//     } = req.body;

//     const profilePicture = req.files?.avatar?.[0]?.cloudinaryUrl || '';

//     const exists = await userModel.findOne({ email: email.toLowerCase().trim() }).lean();
//     if (exists) return res.status(400).json({ message: 'Email already exists.' });

//     const hashedPassword = await HT.hash({
//         plainText: password,
//         SALT_ROUNDS: Number(process.env.SALT_ROUNDS || 12),
//     });

//     const encryptedPhone = await ET.encrypt(phone);

//     // IMPORTANT: confirmed defaults to false in schema
//     const user = await userModel.create({
//         type,
//         firstName,
//         lastName,
//         email: email.toLowerCase().trim(),
//         password: hashedPassword,
//         phone: encryptedPhone,
//         DOB,
//         age,
//         gender,
//         twoFA: !!twoFA,
//         profilePicture,
//     });

//     // Create the correct type doc and return ONLY that one
//     let patient;
//     let doctor;

//     if (user.type === 'patient') {
//         patient = await patientModel.create({ userId: user._id });
//     } else if (user.type === 'doctor') {
//         // if specialization is required at this stage, remove default and validate in signup Joi
//         doctor = await doctorModel.create({ userId: user._id, specialization: 'general' });
//     }

//     // send confirm email
//     eventEmitter.emit('sendEmail', {
//         email: user.email,
//         name: `${user.firstName} ${user.lastName}`,
//     });

//     const tokenId = nanoid();
//     const accessToken = isAdminPrefix(user)
//         ? VT.generateAdminAccessToken(user, '1h', tokenId)
//         : VT.generateUserAccessToken(user, '1h', tokenId);

//     const refreshToken = isAdminPrefix(user)
//         ? VT.generateAdminRefreshToken(user, process.env.JWT_EXPIRES_IN || '7d', tokenId)
//         : VT.generateUserRefreshToken(user, process.env.JWT_EXPIRES_IN || '7d', tokenId);

//     const payload = {
//         message: 'User created successfully. Please confirm your email.',
//         user: publicUser(user),
//         accessToken,
//         refreshToken,
//     };
//     if (user.type === 'patient') payload.patient = patient;
//     if (user.type === 'doctor') payload.doctor = doctor;

//     return res.status(201).json(payload);
// };

// // =========================
// // UPDATED signin
// // =========================
// export const signin = async (req, res) => {
//     const { email, password } = req.body;

//     // lean() breaks instance methods; fine here
//     const user = await userModel
//         .findOne({ email: email.toLowerCase().trim() })
//         .select('+password')
//         .lean();

//     if (!user) return res.status(404).json({ message: 'User Not Found' });

//     if (!user.confirmed) return res.status(400).json({ message: 'Email Not Confirmed' });

//     const ok = await HT.compareHash({ plainText: password, cypherText: user.password });
//     if (!ok) return res.status(400).json({ message: 'Invalid credentials' });

//     // 2FA ON: send OTP + return challenge token only
//     if (user.twoFA) {
//         const otp = otp6();
//         const otpEnc = await ET.encrypt(otp);

//         await userModel.updateOne({ _id: user._id }, { otp: otpEnc });

//         eventEmitter.emit('sendOTP', {
//             email: user.email,
//             otp,
//             name: `${user.firstName} ${user.lastName}`,
//         });

//         const challengeToken = VT.generate2FAToken(user._id, '5m');

//         return res.status(200).json({
//             message: 'OTP sent',
//             requiresOtp: true,
//             challengeToken,
//         });
//     }

//     // 2FA OFF: normal tokens + include only correct type doc
//     const tokenId = nanoid();

//     const accessToken = user.type === 'doctor'
//         ? VT.generateAdminAccessToken(user, '1h', tokenId)
//         : VT.generateUserAccessToken(user, '1h', tokenId);

//     const refreshToken = user.type === 'doctor'
//         ? VT.generateAdminRefreshToken(user, process.env.JWT_EXPIRES_IN || '7d', tokenId)
//         : VT.generateUserRefreshToken(user, process.env.JWT_EXPIRES_IN || '7d', tokenId);

//     const payload = {
//         message: 'User Logged In Successfully',
//         user: publicUser(user),
//         accessToken,
//         refreshToken,
//     };

//     if (user.type === 'patient') {
//         payload.patient = await patientModel.findOne({ userId: user._id }).lean();
//     } else if (user.type === 'doctor') {
//         payload.doctor = await doctorModel.findOne({ userId: user._id }).lean();
//     }

//     return res.status(200).json(payload);
// };

// // =========================
// // UPDATED signinWithOtp
// // =========================
// export const signinWithOtp = async (req, res) => {
//     const { challengeToken, otp } = req.body;

//     let decoded;
//     try {
//         decoded = VT.verify2FAToken(challengeToken);
//     } catch {
//         return res.status(401).json({ message: 'Unauthorized' });
//     }

//     if (decoded?.purpose !== '2fa') return res.status(401).json({ message: 'Unauthorized' });

//     const user = await userModel.findById(decoded.id).select('+otp');
//     if (!user) return res.status(404).json({ message: 'User Not Found' });

//     if (!user.otp) return res.status(400).json({ message: 'Invalid OTP' });

//     const otpPlain = await ET.decrypt(user.otp);
//     if (String(otpPlain) !== String(otp)) return res.status(400).json({ message: 'Invalid OTP' });

//     await userModel.updateOne({ _id: user._id }, { $unset: { otp: 1 } });

//     const tokenId = nanoid();

//     const accessToken = user.type === 'doctor'
//         ? VT.generateAdminAccessToken(user, '1h', tokenId)
//         : VT.generateUserAccessToken(user, '1h', tokenId);

//     const refreshToken = user.type === 'doctor'
//         ? VT.generateAdminRefreshToken(user, process.env.JWT_EXPIRES_IN || '7d', tokenId)
//         : VT.generateUserRefreshToken(user, process.env.JWT_EXPIRES_IN || '7d', tokenId);

//     const uLean = user.toObject();
//     delete uLean.password;
//     delete uLean.otp;

//     const payload = {
//         message: 'User Logged In Successfully',
//         user: publicUser(uLean),
//         accessToken,
//         refreshToken,
//     };

//     if (user.type === 'patient') {
//         payload.patient = await patientModel.findOne({ userId: user._id }).lean();
//     } else if (user.type === 'doctor') {
//         payload.doctor = await doctorModel.findOne({ userId: user._id }).lean();
//     }

//     return res.status(200).json(payload);
// };

// export const requestEmailChange = async (req, res) => {
//     const { newEmail } = req.body;

//     const user = await userModel.findById(req.user.id);
//     if (!user) return res.status(404).json({ message: 'User Not Found' });

//     const exists = await userModel.findOne({ email: newEmail }).lean();
//     if (exists) return res.status(400).json({ message: 'Email already exists.' });

//     user.pendingEmail = newEmail.toLowerCase();
//     user.pendingEmailRequestedAt = new Date();
//     user.confirmed = false; // lock until confirmed
//     await user.save();

//     eventEmitter.emit('sendEmailChangeConfirm', {
//         email: user.pendingEmail, // send to new email
//         name: `${user.firstName} ${user.lastName}`,
//         userId: user._id,
//         oldEmail: user.email,
//         newEmail: user.pendingEmail,
//     });

//     return res.status(200).json({ message: 'Confirmation email sent to new email address.' });
// };

// export const cancelEmailChange = async (req, res) => {
//     const user = await userModel.findById(req.user.id);
//     if (!user) return res.status(404).json({ message: 'User Not Found' });

//     if (!user.pendingEmail) return res.status(400).json({ message: 'No pending email change' });

//     user.pendingEmail = undefined;
//     user.pendingEmailRequestedAt = undefined;

//     // revert confirmed to true because original email was already confirmed
//     user.confirmed = true;

//     await user.save();

//     return res.status(200).json({ message: 'Email change cancelled' });
// };

// export const confirmEmailChange = async (req, res) => {
//     try {
//         const { token } = req.params;

//         const decoded = VT.verifyEmailChangeToken(token);
//         if (!decoded || decoded.purpose !== 'email_change') {
//             return res.status(400).json({ message: 'Invalid Token' });
//         }

//         const user = await userModel.findById(decoded.id);
//         if (!user) return res.status(404).json({ message: 'User Not Found' });

//         const newEmail = String(decoded.newEmail || '').toLowerCase().trim();
//         const oldEmail = String(decoded.oldEmail || '').toLowerCase().trim();

//         // must match current pendingEmail state
//         if (!user.pendingEmail || user.pendingEmail !== newEmail) {
//             return res.status(400).json({ message: 'No pending email change' });
//         }

//         // safety: prevent collision
//         const exists = await userModel.findOne({ email: newEmail }).lean();
//         if (exists && String(exists._id) !== String(user._id)) {
//             return res.status(400).json({ message: 'Email already exists.' });
//         }

//         // apply
//         user.email = newEmail;
//         user.pendingEmail = undefined;
//         user.pendingEmailRequestedAt = undefined;
//         user.confirmed = true;

//         // optional: if decoded.oldEmail mismatch, ignore (token could be older), but keep it for sanity
//         // if (oldEmail && user.email !== oldEmail) ...

//         await user.save();

//         return res.status(200).json({ message: 'Email changed and confirmed successfully' });
//     } catch (err) {
//         if (err?.name === 'JsonWebTokenError') return res.status(400).json({ message: 'Invalid Token' });
//         if (err?.name === 'TokenExpiredError') return res.status(400).json({ message: 'Token Expired' });
//         return res.status(500).json({ message: 'Internal server error.' });
//     }
// };


// export const confirmEmail = async (req, res) => {
//     try {
//         const { token } = req.params;

//         const decoded = VT.verifyConfirmEmailToken(token);
//         if (!decoded?.email) return res.status(400).json({ message: 'Invalid Token' });

//         const user = await userModel.findOne({ email: decoded.email });
//         if (!user) return res.status(404).json({ message: 'User Not Found' });

//         if (user.confirmed) return res.status(400).json({ message: 'Email Already Confirmed' });

//         user.confirmed = true;
//         await user.save();

//         return res.status(200).json({ message: 'Email Confirmed Successfully' });
//     } catch (err) {
//         if (err?.name === 'JsonWebTokenError') return res.status(400).json({ message: 'Invalid Token' });
//         if (err?.name === 'TokenExpiredError') return res.status(400).json({ message: 'Token Expired' });
//         return res.status(500).json({ message: 'Internal server error.' });
//     }
// };

// export const logout = async (req, res) => {
//     const tokenId = req.user.jti;
//     const expiredAt = new Date(Date.now() + 14 * 24 * 60 * 60 * 1000);
//     await revokeTokenModel.create({ tokenId, expiredAt });
//     return res.status(200).json({ message: 'Logged Out Successfully' });
// };

// export const refreshToken = async (req, res) => {
//     const { authorization } = req.headers;
//     if (!authorization) return res.status(401).json({ message: 'Unauthorized' });

//     const [prefix, token] = authorization.split(' ');
//     if (!prefix || !token) return res.status(401).json({ message: 'Unauthorized' });

//     const rotate = async (decoded, isAdmin) => {
//         const isRevoked = await revokeTokenModel.findOne({ tokenId: decoded.jti }).lean();
//         if (isRevoked) return res.status(403).json({ message: 'Please login again' });

//         const user = await userModel.findById(decoded.id);
//         if (!user) return res.status(404).json({ message: 'User Not Found' });

//         const newTokenId = nanoid();

//         const expiredAt = new Date(Date.now() + 14 * 24 * 60 * 60 * 1000);
//         await revokeTokenModel.create({ tokenId: decoded.jti, expiredAt });

//         const accessToken = isAdmin
//             ? VT.generateAdminAccessToken(user, '1h', newTokenId)
//             : VT.generateUserAccessToken(user, '1h', newTokenId);

//         const refreshToken = isAdmin
//             ? VT.generateAdminRefreshToken(user, '14d', newTokenId)
//             : VT.generateUserRefreshToken(user, '14d', newTokenId);

//         return res.status(200).json({
//             message: 'Token refreshed',
//             accessToken,
//             refreshToken,
//         });
//     };

//     if (prefix === process.env.PREFIX_ADMIN) {
//         return VT.verifyAdminRefreshToken(token, async (err, decoded) => {
//             if (err) return res.status(401).json({ message: 'Unauthorized' });
//             return rotate(decoded, true);
//         });
//     }

//     if (prefix === process.env.PREFIX_USER) {
//         return VT.verifyUserRefreshToken(token, async (err, decoded) => {
//             if (err) return res.status(401).json({ message: 'Unauthorized' });
//             return rotate(decoded, false);
//         });
//     }

//     return res.status(401).json({ message: 'Unauthorized' });
// };

// export const requestOTP = async (req, res) => {
//     const { email } = req.body;

//     const user = await userModel.findOne({ email: email.toLowerCase().trim() });
//     if (!user) return res.status(404).json({ message: 'User Not Found' });

//     const otp = otp6();
//     const otpEnc = await ET.encrypt(otp);

//     await userModel.updateOne({ _id: user._id }, { otp: otpEnc });

//     eventEmitter.emit('sendOTP', {
//         email: user.email,
//         otp,
//         name: `${user.firstName} ${user.lastName}`,
//     });

//     return res.status(200).json({ message: 'OTP sent' });
// };


// export const checkOTP = async (req, res) => {
//     const { email, otp } = req.body;

//     const user = await userModel.findOne({ email }).select('+otp');
//     if (!user) return res.status(404).json({ message: 'User Not Found' });

//     if (!user.otp) return res.status(400).json({ message: 'Invalid OTP' });

//     const decryptedOtp = await ET.decrypt(user.otp);
//     if (String(decryptedOtp) !== String(otp)) return res.status(400).json({ message: 'Invalid OTP' });

//     await userModel.updateOne({ _id: user._id }, { $unset: { otp: 1 } });

//     return res.status(200).json({ message: 'OTP Verified Successfully' });
// };

// export const getProfile = async (req, res) => {
//     const user = await userModel.findById(req.user.id).lean();
//     if (!user) return res.status(404).json({ message: 'User Not Found' });

//     return res.status(200).json({ user: publicUser(user) });
// };

// export const getProfileForAll = async (req, res) => {
//     const { id } = req.params;
//     const user = await userModel.findById(id).lean();
//     if (!user) return res.status(404).json({ message: 'User Not Found' });

//     return res.status(200).json({ user: publicUser(user) });
// };

// export const updateProfile = async (req, res) => {
//     const patch = { ...req.body };
//     if (req.files?.avatar?.[0]?.cloudinaryUrl) {
//         patch.profilePicture = req.files.avatar[0].cloudinaryUrl;
//     }

//     if (patch.phone) patch.phone = await ET.encrypt(patch.phone);

//     const user = await userModel.findByIdAndUpdate(req.user.id, patch, { new: true }).lean();
//     if (!user) return res.status(404).json({ message: 'User Not Found' });

//     return res.status(200).json({ message: 'Profile Updated Successfully', user: publicUser(user) });
// };

// export const resendConfirmEmail = async (req, res) => {
//     try {
//         const user = await userModel.findById(req.user.id).lean();
//         if (!user) return res.status(404).json({ message: 'User Not Found' });

//         if (user.confirmed) return res.status(400).json({ message: 'Email Already Confirmed' });

//         eventEmitter.emit('sendEmail', { email: user.email, name: `${user.firstName} ${user.lastName}` });

//         return res.status(200).json({ message: 'Confirmation email sent successfully.' });
//     } catch {
//         return res.status(500).json({ message: 'Internal server error.' });
//     }
// };

// export const toggle2FA = async (req, res) => {
//     const { enabled } = req.body;

//     const user = await userModel.findById(req.user.id);
//     if (!user) return res.status(404).json({ message: 'User Not Found' });

//     user.twoFA = !!enabled;

//     if (!user.twoFA) {
//         user.otp = undefined;
//     }

//     await user.save();

//     return res.status(200).json({ message: '2FA updated', twoFA: user.twoFA });
// };


import userModel from '../../models/user.model.js';
import patientModel from '../../models/patient.model.js';
import doctorModel from '../../models/doctor.model.js';
import { revokeTokenModel } from '../../models/revoke-token.model.js';

import * as HT from '../../utils/hash/index.js';
import * as ET from '../../utils/encryption/index.js';
import * as VT from '../../utils/token/index.js';
import { otp6 } from '../../utils/index.js';
import { nanoid } from 'nanoid';

import { sendEmailEvent, sendOTPEvent, sendEmailChangeConfirmEvent } from '../../utils/sendEmail-events/index.js';

const isAdminPrefix = (user) => user?.type === 'doctor';

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

const attachTypeDoc = async (user) => {
    if (user.type === 'patient') return { patient: await patientModel.findOne({ userId: user._id }).lean() };
    if (user.type === 'doctor') return { doctor: await doctorModel.findOne({ userId: user._id }).lean() };
    return {};
};

export const signup = async (req, res) => {
    try {
        const {
            firstName,
            lastName,
            email,
            password,
            // confirmPassword, // validated by Joi, ignored in service
            type,
            twoFA,
        } = req.body;

        const emailNorm = email.toLowerCase().trim();

        const exists = await userModel.findOne({ email: emailNorm }).lean();
        if (exists) return res.status(400).json({ message: "Email already exists." });

        // cloudinary (if you already use it)
        // const profilePicture = req.files?.avatar?.[0]?.cloudinaryUrl || "";

        const hashedPassword = await HT.hash({
            plainText: password,
            SALT_ROUNDS: Number(process.env.SALT_ROUNDS || 12),
        });

        const user = await userModel.create({
            type,
            firstName,
            lastName,
            email: emailNorm,
            password: hashedPassword,
            // twoFA: !!twoFA,
            // profilePicture,
            // confirmed: false,
        });

        // Create the correct type doc
        let patient = undefined;
        let doctor = undefined;

        if (user.type === "patient") {
            patient = await patientModel.create({ userId: user._id });
        } else if (user.type === "doctor") {
            doctor = await doctorModel.create({ userId: user._id });
        }

        // eventEmitter.emit("sendEmail", {
        //     email: user.email,
        //     name: `${user.firstName} ${user.lastName}`,
        // });
        await sendEmailEvent({
            email: user.email,
            name: `${user.firstName} ${user.lastName}`,
        });

        // tokens
        const tokenId = nanoid();
        const accessToken = isAdminPrefix(user)
            ? VT.generateAdminAccessToken(user, "1h", tokenId)
            : VT.generateUserAccessToken(user, "1h", tokenId);

        const refreshToken = isAdminPrefix(user)
            ? VT.generateAdminRefreshToken(user, process.env.JWT_EXPIRES_IN || "7d", tokenId)
            : VT.generateUserRefreshToken(user, process.env.JWT_EXPIRES_IN || "7d", tokenId);

        // Return only correct type data
        const payload = {
            message: "User created successfully. Please confirm your email.",
            user: publicUser(user),
            accessToken,
            refreshToken,
        };

        if (user.type === "patient") payload.patient = patient;
        if (user.type === "doctor") payload.doctor = doctor;

        return res.status(201).json(payload);
    } catch (err) {
        console.error("Signup error:", err.message);
        return res.status(500).json({ message: "Internal server error." });
    }
};

export const signin = async (req, res) => {
    const { email, password } = req.body;

    const user = await userModel.findOne({ email: email.toLowerCase().trim() }).select('+password').lean();
    if (!user) return res.status(404).json({ message: 'User Not Found' });
    if (!user.confirmed) return res.status(400).json({ message: 'Email Not Confirmed' });

    const ok = await HT.compareHash({ plainText: password, cypherText: user.password });
    if (!ok) return res.status(400).json({ message: 'Invalid credentials' });

    if (user.twoFA) {
        const otp = otp6();
        const otpEnc = await ET.encrypt(otp);
        await userModel.updateOne({ _id: user._id }, { otp: otpEnc });

        // eventEmitter.emit('sendOTP', { email: user.email, otp, name: `${user.firstName} ${user.lastName}` });
        await sendOTPEvent({ email: user.email, otp, name: `${user.firstName} ${user.lastName}` });

        const challengeToken = VT.generate2FAToken(user._id, '5m');
        return res.status(200).json({ message: 'OTP sent', requiresOtp: true, challengeToken });
    }

    const tokenId = nanoid();
    const accessToken = isAdminPrefix(user) ? VT.generateAdminAccessToken(user, '1h', tokenId) : VT.generateUserAccessToken(user, '1h', tokenId);
    const refreshToken = isAdminPrefix(user) ? VT.generateAdminRefreshToken(user, process.env.JWT_EXPIRES_IN || '7d', tokenId) : VT.generateUserRefreshToken(user, process.env.JWT_EXPIRES_IN || '7d', tokenId);

    const typeDoc = await attachTypeDoc(user);

    return res.status(200).json({
        message: 'User Logged In Successfully',
        user: publicUser(user),
        ...typeDoc,
        accessToken,
        refreshToken,
    });
};

export const signinWithOtp = async (req, res) => {
    const { challengeToken, otp } = req.body;

    let decoded;
    try {
        decoded = VT.verify2FAToken(challengeToken);
    } catch {
        return res.status(401).json({ message: 'Unauthorized' });
    }
    if (decoded?.purpose !== '2fa') return res.status(401).json({ message: 'Unauthorized' });

    const user = await userModel.findById(decoded.id).select('+otp');
    if (!user) return res.status(404).json({ message: 'User Not Found' });
    if (!user.otp) return res.status(400).json({ message: 'Invalid OTP' });

    const otpPlain = await ET.decrypt(user.otp);
    if (String(otpPlain) !== String(otp)) return res.status(400).json({ message: 'Invalid OTP' });

    await userModel.updateOne({ _id: user._id }, { $unset: { otp: 1 } });

    const tokenId = nanoid();
    const accessToken = isAdminPrefix(user) ? VT.generateAdminAccessToken(user, '1h', tokenId) : VT.generateUserAccessToken(user, '1h', tokenId);
    const refreshToken = isAdminPrefix(user) ? VT.generateAdminRefreshToken(user, process.env.JWT_EXPIRES_IN || '7d', tokenId) : VT.generateUserRefreshToken(user, process.env.JWT_EXPIRES_IN || '7d', tokenId);

    const typeDoc = await attachTypeDoc(user);

    return res.status(200).json({
        message: 'User Logged In Successfully',
        user: publicUser(user),
        ...typeDoc,
        accessToken,
        refreshToken,
    });
};

export const confirmEmail = async (req, res) => {
    try {
        const { token } = req.params;
        const decoded = VT.verifyConfirmEmailToken(token);
        if (!decoded?.email) return res.status(400).json({ message: 'Invalid Token' });

        const user = await userModel.findOne({ email: decoded.email.toLowerCase().trim() });
        if (!user) return res.status(404).json({ message: 'User Not Found' });
        if (user.confirmed) return res.status(400).json({ message: 'Email Already Confirmed' });

        user.confirmed = true;
        await user.save();
        return res.status(200).json({ message: 'Email Confirmed Successfully' });
    } catch (err) {
        if (err?.name === 'JsonWebTokenError') return res.status(400).json({ message: 'Invalid Token' });
        if (err?.name === 'TokenExpiredError') return res.status(400).json({ message: 'Token Expired' });
        return res.status(500).json({ message: 'Internal server error.' });
    }
};

export const requestEmailChange = async (req, res) => {
    const { newEmail } = req.body;

    const user = await userModel.findById(req.user.id);
    if (!user) return res.status(404).json({ message: 'User Not Found' });

    const exists = await userModel.findOne({ email: newEmail.toLowerCase().trim() }).lean();
    if (exists) return res.status(400).json({ message: 'Email already exists.' });

    user.pendingEmail = newEmail.toLowerCase().trim();
    user.pendingEmailRequestedAt = new Date();
    user.confirmed = false;
    await user.save();

    // eventEmitter.emit('sendEmailChangeConfirm', {
    //     email: user.pendingEmail,
    //     name: `${user.firstName} ${user.lastName}`,
    //     userId: user._id,
    //     oldEmail: user.email,
    //     newEmail: user.pendingEmail,
    // });
    await sendEmailChangeConfirmEvent({
        email: user.pendingEmail,
        name: `${user.firstName} ${user.lastName}`,
        userId: user._id,
        oldEmail: user.email,
        newEmail: user.pendingEmail,
    });

    return res.status(200).json({ message: 'Confirmation email sent to new email address.' });
};

export const cancelEmailChange = async (req, res) => {
    const user = await userModel.findById(req.user.id);
    if (!user) return res.status(404).json({ message: 'User Not Found' });

    if (!user.pendingEmail) return res.status(400).json({ message: 'No pending email change' });

    user.pendingEmail = undefined;
    user.pendingEmailRequestedAt = undefined;
    user.confirmed = true;

    await user.save();
    return res.status(200).json({ message: 'Email change cancelled' });
};

export const confirmEmailChange = async (req, res) => {
    try {
        const { token } = req.params;
        const decoded = VT.verifyEmailChangeToken(token);
        if (!decoded || decoded.purpose !== 'email_change') return res.status(400).json({ message: 'Invalid Token' });

        const user = await userModel.findById(decoded.id);
        if (!user) return res.status(404).json({ message: 'User Not Found' });

        const newEmail = String(decoded.newEmail || '').toLowerCase().trim();
        if (!user.pendingEmail || user.pendingEmail !== newEmail) return res.status(400).json({ message: 'No pending email change' });

        const exists = await userModel.findOne({ email: newEmail }).lean();
        if (exists && String(exists._id) !== String(user._id)) return res.status(400).json({ message: 'Email already exists.' });

        user.email = newEmail;
        user.pendingEmail = undefined;
        user.pendingEmailRequestedAt = undefined;
        user.confirmed = true;

        await user.save();
        return res.status(200).json({ message: 'Email changed and confirmed successfully' });
    } catch (err) {
        if (err?.name === 'JsonWebTokenError') return res.status(400).json({ message: 'Invalid Token' });
        if (err?.name === 'TokenExpiredError') return res.status(400).json({ message: 'Token Expired' });
        return res.status(500).json({ message: 'Internal server error.' });
    }
};

export const toggle2FA = async (req, res) => {
    const { enabled } = req.body;

    const user = await userModel.findById(req.user.id);
    if (!user) return res.status(404).json({ message: 'User Not Found' });

    user.twoFA = !!enabled;
    if (!user.twoFA) user.otp = undefined;

    await user.save();
    return res.status(200).json({ message: '2FA updated', twoFA: user.twoFA });
};

export const getMe = async (req, res) => {
    const user = await userModel.findById(req.user.id).lean();
    if (!user) return res.status(404).json({ message: 'User Not Found' });

    const typeDoc = await attachTypeDoc(user);

    return res.status(200).json({ user: publicUser(user), ...typeDoc });
};

export const logout = async (req, res) => {
    const tokenId = req.user.jti;
    const expiredAt = new Date(Date.now() + 14 * 24 * 60 * 60 * 1000);
    await revokeTokenModel.create({ tokenId, expiredAt });
    return res.status(200).json({ message: 'Logged Out Successfully' });
};

export const refreshToken = async (req, res) => {
    const { authorization } = req.headers;
    if (!authorization) return res.status(401).json({ message: 'Unauthorized' });

    const [prefix, token] = authorization.split(' ');
    if (!prefix || !token) return res.status(401).json({ message: 'Unauthorized' });

    const rotate = async (decoded, isAdmin) => {
        const isRevoked = await revokeTokenModel.findOne({ tokenId: decoded.jti }).lean();
        if (isRevoked) return res.status(403).json({ message: 'Please login again' });

        const user = await userModel.findById(decoded.id);
        if (!user) return res.status(404).json({ message: 'User Not Found' });

        const newTokenId = nanoid();
        const expiredAt = new Date(Date.now() + 14 * 24 * 60 * 60 * 1000);
        await revokeTokenModel.create({ tokenId: decoded.jti, expiredAt });

        const accessToken = isAdmin ? VT.generateAdminAccessToken(user, '1h', newTokenId) : VT.generateUserAccessToken(user, '1h', newTokenId);
        const refreshToken = isAdmin ? VT.generateAdminRefreshToken(user, '14d', newTokenId) : VT.generateUserRefreshToken(user, '14d', newTokenId);

        return res.status(200).json({ message: 'Token refreshed', accessToken, refreshToken });
    };

    if (prefix === process.env.PREFIX_ADMIN) {
        return VT.verifyAdminRefreshToken(token, async (err, decoded) => {
            if (err) return res.status(401).json({ message: 'Unauthorized' });
            return rotate(decoded, true);
        });
    }

    if (prefix === process.env.PREFIX_USER) {
        return VT.verifyUserRefreshToken(token, async (err, decoded) => {
            if (err) return res.status(401).json({ message: 'Unauthorized' });
            return rotate(decoded, false);
        });
    }

    return res.status(401).json({ message: 'Unauthorized' });
};

export const requestOTP = async (req, res) => {
    const { email } = req.body;

    const user = await userModel.findOne({ email: email.toLowerCase().trim() });
    if (!user) return res.status(404).json({ message: 'User Not Found' });

    const otp = otp6();
    const otpEnc = await ET.encrypt(otp);

    await userModel.updateOne({ _id: user._id }, { otp: otpEnc });

    // eventEmitter.emit('sendOTP', {
    //     email: user.email,
    //     otp,
    //     name: `${user.firstName} ${user.lastName}`,
    // });
    await sendOTPEvent({
        email: user.email,
        otp,
        name: `${user.firstName} ${user.lastName}`,
    });

    return res.status(200).json({ message: 'OTP sent' });
};

export const checkOTP = async (req, res) => {
    const { email, otp } = req.body;

    const user = await userModel.findOne({ email: email.toLowerCase().trim() }).select('+otp');
    if (!user) return res.status(404).json({ message: 'User Not Found' });

    if (!user.otp) return res.status(400).json({ message: 'Invalid OTP' });

    const decryptedOtp = await ET.decrypt(user.otp);
    if (String(decryptedOtp) !== String(otp)) return res.status(400).json({ message: 'Invalid OTP' });

    await userModel.updateOne({ _id: user._id }, { $unset: { otp: 1 } });

    return res.status(200).json({ message: 'OTP Verified Successfully' });
};

export const forgetPassword = async (req, res) => {
    const { email } = req.body;

    const user = await userModel.findOne({ email: email.toLowerCase().trim() });
    if (!user) return res.status(404).json({ message: 'User Not Found' });

    const otp = otp6();
    const otpEnc = await ET.encrypt(otp);

    await userModel.updateOne({ _id: user._id }, { otp: otpEnc });

    // eventEmitter.emit('sendOTP', {
    //     email: user.email,
    //     otp,
    //     name: `${user.firstName} ${user.lastName}`,
    // });
    await sendOTPEvent({
        email: user.email,
        otp,
        name: `${user.firstName} ${user.lastName}`,
    });

    return res.status(200).json({ message: 'Password reset OTP sent to email' });
};

export const verifyForgetPasswordOTP = async (req, res) => {
    const { email, otp } = req.body;

    const user = await userModel.findOne({ email: email.toLowerCase().trim() }).select('+otp');
    if (!user) return res.status(404).json({ message: 'User Not Found' });

    if (!user.otp) return res.status(400).json({ message: 'Invalid OTP' });

    const decryptedOtp = await ET.decrypt(user.otp);
    if (String(decryptedOtp) !== String(otp)) return res.status(400).json({ message: 'Invalid OTP' });

    await userModel.updateOne({ _id: user._id }, { $unset: { otp: 1 } });

    const resetToken = VT.generateResetPasswordToken(user._id);

    return res.status(200).json({ message: 'OTP Verified Successfully', resetToken });
};

export const getProfileForAll = async (req, res) => {
    const { id } = req.params;
    const user = await userModel.findById(id).lean();
    if (!user) return res.status(404).json({ message: 'User Not Found' });

    const typeDoc = await attachTypeDoc(user);

    return res.status(200).json({ user: publicUser(user), ...typeDoc });
};

export const updateProfile = async (req, res) => {
    const patch = { ...req.body };
    if (req.files?.avatar?.[0]?.cloudinaryUrl) {
        patch.profilePicture = req.files.avatar[0].cloudinaryUrl;
    }

    if (patch.phone) patch.phone = await ET.encrypt(patch.phone);

    const user = await userModel.findByIdAndUpdate(req.user.id, patch, { new: true }).lean();
    if (!user) return res.status(404).json({ message: 'User Not Found' });

    const typeDoc = await attachTypeDoc(user);

    return res.status(200).json({ message: 'Profile Updated Successfully', user: publicUser(user), ...typeDoc });
};

export const resendConfirmEmail = async (req, res) => {
    try {
        const user = await userModel.findById(req.user.id).lean();
        if (!user) return res.status(404).json({ message: 'User Not Found' });

        if (user.confirmed) return res.status(400).json({ message: 'Email Already Confirmed' });

        // eventEmitter.emit('sendEmail', { email: user.email, name: `${user.firstName} ${user.lastName}` });
        await sendEmailEvent({ email: user.email, name: `${user.firstName} ${user.lastName}` });

        return res.status(200).json({ message: 'Confirmation email sent successfully.' });
    } catch {
        return res.status(500).json({ message: 'Internal server error.' });
    }
};

export const changePassword = async (req, res) => {
    try {
        const { oldPassword, newPassword } = req.body;

        const user = await userModel.findById(req.user.id).select('+password');
        if (!user) return res.status(404).json({ message: 'User Not Found' });

        const ok = await HT.compareHash({ plainText: oldPassword, cypherText: user.password });
        if (!ok) return res.status(400).json({ message: 'Incorrect old password' });

        const hashedPassword = await HT.hash({
            plainText: newPassword,
            SALT_ROUNDS: Number(process.env.SALT_ROUNDS || 12),
        });

        user.password = hashedPassword;
        await user.save();

        return res.status(200).json({ message: 'Password changed successfully' });
    } catch (err) {
        return res.status(500).json({ message: 'Internal server error.' });
    }
};

export const resetPassword = async (req, res) => {
    try {
        const { resetToken, newPassword } = req.body;

        let decoded;
        try {
            decoded = VT.verifyResetPasswordToken(resetToken);
        } catch {
            return res.status(400).json({ message: 'Invalid or expired reset token' });
        }

        if (decoded?.purpose !== 'reset_password') return res.status(400).json({ message: 'Invalid token purpose' });

        const user = await userModel.findById(decoded.id);
        if (!user) return res.status(404).json({ message: 'User Not Found' });

        const hashedPassword = await HT.hash({
            plainText: newPassword,
            SALT_ROUNDS: Number(process.env.SALT_ROUNDS || 12),
        });

        user.password = hashedPassword;
        await user.save();

        return res.status(200).json({ message: 'Password reset successfully' });
    } catch (err) {
        return res.status(500).json({ message: 'Internal server error.' });
    }
};