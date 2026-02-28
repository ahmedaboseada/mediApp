import { revokeTokenModel } from '../models/revoke-token.model.js';
import * as VT from '../utils/token/verifyToken.js';
import userModel from '../models/user.model.js';

export const verifyToken = (req, res, next) => {
    const { authorization } = req.headers;
    if (!authorization) return res.status(401).json({ message: 'Unauthorized' });

    const [prefixRaw, token] = authorization.split(' ');
    const prefix = (prefixRaw || '').toLowerCase();

    if (!prefix || !token) return res.status(401).json({ message: 'Unauthorized' });

    const check = async (decoded) => {
        if (!decoded?.jti || !decoded?.id) return res.status(401).json({ message: 'Unauthorized' });

        const isRevoked = await revokeTokenModel.findOne({ tokenId: decoded.jti }).lean();
        if (isRevoked) return res.status(403).json({ message: 'Please login again' });

        const user = await userModel.findById(decoded.id).lean();
        if (!user) return res.status(404).json({ message: 'User Not Found' });

        req.user = decoded;
        next();
    };

    if (prefix === String(process.env.PREFIX_ADMIN || '').toLowerCase()) {
        return VT.verifyAdminAccessToken(token, async (err, decoded) => {
            if (err) return res.status(401).json({ message: 'Unauthorized' });
            return check(decoded);
        });
    }

    if (prefix === String(process.env.PREFIX_USER || '').toLowerCase()) {
        return VT.verifyUserAccessToken(token, async (err, decoded) => {
            if (err) return res.status(401).json({ message: 'Unauthorized' });
            return check(decoded);
        });
    }

    return res.status(401).json({ message: 'Unauthorized' });
};
