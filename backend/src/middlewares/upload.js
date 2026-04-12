import multer from 'multer';
import { Errors } from '../config/utils/apiError.js';

const storage = multer.memoryStorage();

export const upload = multer({
    storage,
    limits: { fileSize: 2 * 1024 * 1024, files: 1 },
    fileFilter: (_req, file, cb) => {
        const ok = ['image/jpeg', 'image/png', 'image/webp'].includes(file.mimetype);
        if (!ok) return cb(Errors.validation('Invalid file type', [{ path: 'file', message: 'Only jpg/png/webp' }]));
        cb(null, true);
    },
});
