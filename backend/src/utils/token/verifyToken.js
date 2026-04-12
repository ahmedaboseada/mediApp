import jwt from 'jsonwebtoken';

export const verifyAdminAccessToken = (token, cb) =>
    jwt.verify(token, process.env.JWT_ACCESS_ADMIN_SECRET, cb);

export const verifyUserAccessToken = (token, cb) =>
    jwt.verify(token, process.env.JWT_ACCESS_USER_SECRET, cb);

export const verifyAdminRefreshToken = (token, cb) =>
    jwt.verify(token, process.env.JWT_REFRESH_ADMIN_SECRET, cb);

export const verifyUserRefreshToken = (token, cb) =>
    jwt.verify(token, process.env.JWT_REFRESH_USER_SECRET, cb);

export const verifyConfirmEmailToken = (token) =>
    jwt.verify(token, process.env.JWT_EMAIL_CONFIRM_SECRET);
