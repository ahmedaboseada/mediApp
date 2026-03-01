import { signToken } from './tokenGenerator.js';
import * as V from './verifyToken.js';

const exp = () => process.env.JWT_EXPIRES_IN || '7d';

export const generateUserAccessToken = (user, expiresIn = '1h', tokenId) =>
    signToken({
        payload: { id: String(user._id), type: user.type },
        secret: process.env.JWT_ACCESS_USER_SECRET,
        expiresIn,
        tokenId,
    }).token;

export const generateUserRefreshToken = (user, expiresIn = exp(), tokenId) =>
    signToken({
        payload: { id: String(user._id), type: user.type },
        secret: process.env.JWT_REFRESH_USER_SECRET,
        expiresIn,
        tokenId,
    }).token;

export const generateAdminAccessToken = (user, expiresIn = '1h', tokenId) =>
    signToken({
        payload: { id: String(user._id), type: user.type },
        secret: process.env.JWT_ACCESS_ADMIN_SECRET,
        expiresIn,
        tokenId,
    }).token;

export const generateAdminRefreshToken = (user, expiresIn = exp(), tokenId) =>
    signToken({
        payload: { id: String(user._id), type: user.type },
        secret: process.env.JWT_REFRESH_ADMIN_SECRET,
        expiresIn,
        tokenId,
    }).token;

export const verifyAdminAccessToken = V.verifyAdminAccessToken;
export const verifyUserAccessToken = V.verifyUserAccessToken;
export const verifyAdminRefreshToken = V.verifyAdminRefreshToken;
export const verifyUserRefreshToken = V.verifyUserRefreshToken;
export const verifyConfirmEmailToken = V.verifyConfirmEmailToken;

export const generateConfirmEmailToken = (email, expiresIn = '7d') =>
    signToken({
        payload: { email },
        secret: process.env.JWT_EMAIL_CONFIRM_SECRET,
        expiresIn,
    }).token;

export const generate2FAToken = (userId, expiresIn = '5m') =>
    signToken({
        payload: { id: String(userId), purpose: '2fa' },
        secret: process.env.JWT_2FA_SECRET,
        expiresIn,
    }).token;

import jwt from 'jsonwebtoken';

export const verify2FAToken = (token) => {
    return jwt.verify(token, process.env.JWT_2FA_SECRET);
};

export const generateEmailChangeToken = ({ userId, oldEmail, newEmail }, expiresIn = '1h') =>
    signToken({
        payload: { id: String(userId), oldEmail, newEmail, purpose: 'email_change' },
        secret: process.env.JWT_EMAIL_CHANGE_SECRET,
        expiresIn,
    }).token;

export const verifyEmailChangeToken = (token) => {
    return jwt.verify(token, process.env.JWT_EMAIL_CHANGE_SECRET);
};

export const generateResetPasswordToken = (userId, expiresIn = '15m') =>
    signToken({
        payload: { id: String(userId), purpose: 'reset_password' },
        secret: process.env.JWT_RESET_PASSWORD_SECRET || 'fallback_reset_secret',
        expiresIn,
    }).token;

export const verifyResetPasswordToken = (token) => {
    return jwt.verify(token, process.env.JWT_RESET_PASSWORD_SECRET || 'fallback_reset_secret');
};
