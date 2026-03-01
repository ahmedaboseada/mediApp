import bcrypt from 'bcrypt';

export const hash = ({ plainText, SALT_ROUNDS }) => bcrypt.hash(plainText, SALT_ROUNDS);