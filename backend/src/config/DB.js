import mongoose from 'mongoose';

export default async function connectDB() {
    const uri = process.env.MONGO_URI_ONLINE || process.env.MONGO_URI;
    if (!uri) throw new Error('Missing MONGO_URI');

    await mongoose.connect(uri, {
        autoIndex: process.env.NODE_ENV !== 'production',
        serverSelectionTimeoutMS: 10_000,
    });

    console.log('DB connected');
}
