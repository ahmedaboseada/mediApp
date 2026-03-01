import crypto from 'crypto';

const ALGO = 'aes-256-gcm';

const keyFromEnv = () => {
    const k = process.env.ENCRYPTION_KEY;
    if (!k || k.length < 32) throw new Error('ENCRYPTION_KEY missing/weak');
    return crypto.createHash('sha256').update(k).digest();
};

export const decrypt = async (blob) => {
    if (!blob) return blob;

    const key = keyFromEnv();
    const [ivHex, tagHex, dataHex] = String(blob).split('.');

    const iv = Buffer.from(ivHex, 'hex');
    const tag = Buffer.from(tagHex, 'hex');
    const data = Buffer.from(dataHex, 'hex');

    const decipher = crypto.createDecipheriv(ALGO, key, iv);
    decipher.setAuthTag(tag);

    const dec = Buffer.concat([decipher.update(data), decipher.final()]);
    return dec.toString('utf8');
};
