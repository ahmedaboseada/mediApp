import nodemailer from 'nodemailer';
import fs from 'fs/promises';
import path from 'path';
import dotenv from 'dotenv';

dotenv.config();

const __dirname = path.resolve();

export const sendEmail = async ({ to, subject, name, message }) => {
    try {
        const templatePath = path.join(__dirname, 'src','utils', 'templates', 'emailTemplate.html');
        let htmlContent = await fs.readFile(templatePath, 'utf-8');

        htmlContent = htmlContent.replace('{{name}}', name).replace('{{message}}', message);

        const transporter = nodemailer.createTransport({
            service: 'gmail',
            auth: {
                user: process.env.SMTP_USER,
                pass: process.env.SMTP_PASS
            }
        });

        const mailOptions = {
            from: `"ListifyMe" <${process.env.SMTP_USER}>`,
            to,
            subject,
            html: htmlContent
        };

        const info = await transporter.sendMail(mailOptions);
        return { success: true, messageId: info.messageId };
    } catch (error) {
        console.error('Error sending email:', error.message);
        return { success: false, error: error.message };
    }
};
