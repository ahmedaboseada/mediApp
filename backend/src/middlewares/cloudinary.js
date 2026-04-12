import cloudinary from '../config/cloudinary.js';
import { multerUpload } from './multer.js';

const uploadBuffer = (buffer, folder, resource_type = 'image') =>
    new Promise((resolve, reject) => {
        const stream = cloudinary.uploader.upload_stream(
            { folder, resource_type },
            (error, result) => {
                if (error) return reject(error);
                resolve(result);
            },
        );
        stream.end(buffer);
    });

export const cloudinaryUploadAvatarAndCover = ({ folder = 'uploads' } = {}) => {
    const fields = [
        { name: 'avatar', maxCount: 1 },
        { name: 'images', maxCount: 10 },
        { name: 'licenseImage', maxCount: 1 },
    ];

    return [
        multerUpload.fields(fields),
        async (req, _res, next) => {
            try {
                if (!req.files) return next();

                const out = {};

                if (req.files.avatar?.[0]) {
                    const f = req.files.avatar[0];
                    const r = await uploadBuffer(f.buffer, `${folder}/avatarImages`, 'image');
                    out.avatar = [
                        {
                            cloudinaryUrl: r.secure_url,
                            publicId: r.public_id,
                        },
                    ];
                }

                if (Array.isArray(req.files.images) && req.files.images.length) {
                    out.images = [];
                    for (const f of req.files.images) {
                        const r = await uploadBuffer(f.buffer, `${folder}/coverImages`, 'image');
                        out.images.push({ cloudinaryUrl: r.secure_url, publicId: r.public_id });
                    }
                }

                if (req.files.licenseImage?.[0]) {
                    const f = req.files.licenseImage[0];
                    const r = await uploadBuffer(f.buffer, `${folder}/licenseImages`, 'image');
                    out.licenseImage = [
                        {
                            cloudinaryUrl: r.secure_url,
                            publicId: r.public_id,
                        },
                    ];
                }

                req.files = out;
                next();
            } catch (e) {
                next(e);
            }
        },
    ];
};
