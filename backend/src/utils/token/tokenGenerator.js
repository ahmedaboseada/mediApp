import jwt from 'jsonwebtoken';
import { nanoid } from 'nanoid';

export const signToken = ({ payload, secret, expiresIn, tokenId }) => {
    const jti = tokenId || nanoid();
    const token = jwt.sign({ ...payload, jti }, secret, { expiresIn });
    return { token, jti };
};
