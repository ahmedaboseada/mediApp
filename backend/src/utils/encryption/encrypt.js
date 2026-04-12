import crypto from 'crypto';

const ALGO = 'aes-256-gcm';

const keyFromEnv = () => {
    const k = process.env.ENCRYPTION_KEY;
    if (!k || k.length < 32) throw new Error('ENCRYPTION_KEY missing/weak');
    return crypto.createHash('sha256').update(k).digest();
};

export const encrypt = async (plainText) => {
    if (plainText === undefined || plainText === null) return plainText;

    const key = keyFromEnv();
    const iv = crypto.randomBytes(12);

    const cipher = crypto.createCipheriv(ALGO, key, iv);
    const enc = Buffer.concat([cipher.update(String(plainText), 'utf8'), cipher.final()]);
    const tag = cipher.getAuthTag();

    return `${iv.toString('hex')}.${tag.toString('hex')}.${enc.toString('hex')}`;
};
