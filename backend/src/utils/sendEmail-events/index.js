import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { sendEmail } from '../sendEmail.js';
import * as VT from '../token/index.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const templatePath = path.join(__dirname, '..', 'templates', 'emailTemplate.html');

// export const eventEmitter = new EventEmitter();

const loadTemplate = () => fs.readFileSync(templatePath, 'utf8');

const render = ({ name, content, link }) => {
    const tpl = loadTemplate();

    const linkBlock = link
        ? `<a href="${link}" target="_blank" rel="noreferrer">Open Link</a>`
        : '';

    return tpl
        .replaceAll('{{NAME}}', name || 'User')
        .replaceAll('{{CONTENT}}', content || '')
        .replaceAll('{{LINK_BLOCK}}', linkBlock);
};

// eventEmitter.on('sendEmail', async ({ email, name }) => {
//     try {
//         const token = VT.generateConfirmEmailToken(email, process.env.JWT_EXPIRES_IN || '1d');
//         const base = process.env.APP_BASE_URL || `http://localhost:${process.env.PORT || 8000}`;
//         const link = `${base}/users/confirmEmail/${token}`;
//         const html = render({ name, content: 'Confirm your email by using the link below.', link });
//         await sendEmail({ to: email, subject: 'Confirm your email', html, text: `Confirm your email: ${link}` });
//         console.log("✅ confirm email sent:", email);
//     } catch (err) {
//         console.error("❌ sendEmail event failed:", err?.message);
//         console.error(err);
//     }
// });

// send confirm email
export const sendEmailEvent = async ({ email, name, tokenId }) => {
    try {
        const token = VT.generateConfirmEmailToken(email, process.env.JWT_EXPIRES_IN || '1d', tokenId);

        const base = process.env.APP_BASE_URL || `http://localhost:${process.env.PORT || 8000}`;
        const link = `${base}/users/confirmEmail/${token}`;

        const html = render({
            name,
            content: 'Confirm your email by using the link below.',
            link,
        });

        await sendEmail({
            to: email,
            subject: 'Confirm your email',
            html,
            text: `Confirm your email: ${link}`,
        });

        console.log("✅ confirm email sent:", email);
    } catch (err) {
        console.error("❌ sendEmail event failed:", err?.message);
        console.error(err); // keep full stack
    }
};

// eventEmitter.on('sendOTP', async ({ email, otp, name }) => {
//     try {
//         const html = render({ name, content: `Your OTP code is: ${otp}`, link: null });
//         await sendEmail({ to: email, subject: 'Your OTP code', html, text: `OTP: ${otp}` });
//         console.log("✅ OTP sent:", email);
//     } catch (err) {
//         console.error("❌ sendOTP event failed:", err?.message);
//         console.error(err);
//     }
// });

// send OTP
export const sendOTPEvent = async ({ email, otp, name }) => {
    try {
        const html = render({
            name,
            content: `Your OTP code is: ${otp}`,
            link: null,
        });

        await sendEmail({
            to: email,
            subject: 'Your OTP code',
            html,
            text: `OTP: ${otp}`,
        });

        console.log("✅ OTP sent:", email);
    } catch (err) {
        console.error("❌ sendOTP event failed:", err?.message);
        console.error(err);
    }
};

// eventEmitter.on('sendEmailChangeConfirm', async ({ email, name, userId, oldEmail, newEmail }) => {
//     try {
//         const token = VT.generateEmailChangeToken({ userId, oldEmail, newEmail }, '1h');
//         const base = process.env.APP_BASE_URL || `http://localhost:${process.env.PORT || 8000}`;
//         const link = `${base}/users/confirmEmailChange/${token}`;
//         const html = render({ name, content: `Confirm changing your email to: ${newEmail}`, link });
//         await sendEmail({ to: email, subject: 'Confirm email change', html, text: `Confirm email change: ${link}` });
//         console.log("✅ email change confirm sent:", email);
//     } catch (err) {
//         console.error("❌ sendEmailChangeConfirm event failed:", err?.message);
//         console.error(err);
//     }
// });

export const sendEmailChangeConfirmEvent = async ({ email, name, userId, oldEmail, newEmail, tokenId }) => {
    try {
        const token = VT.generateEmailChangeToken({ userId, oldEmail, newEmail }, '1h', tokenId);

        const base = process.env.APP_BASE_URL || `http://localhost:${process.env.PORT || 8000}`;
        const link = `${base}/users/confirmEmailChange/${token}`;

        const html = render({
            name,
            content: `Confirm changing your email to: ${newEmail}`,
            link,
        });

        await sendEmail({
            to: email,
            subject: 'Confirm email change',
            html,
            text: `Confirm email change: ${link}`,
        });

        console.log("✅ email change confirm sent:", email);
    } catch (err) {
        console.error("❌ sendEmailChangeConfirm event failed:", err?.message);
        console.error(err);
    }
};
