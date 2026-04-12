import bcrypt from 'bcrypt';

export const compareHash = ({ plainText, cypherText }) => bcrypt.compare(plainText, cypherText);
