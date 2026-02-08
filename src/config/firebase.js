import admin from "firebase-admin";
import serviceAccount from "./listifyme-45792-75a14d416530.json";

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

const messaging = admin.messaging();

// Usage example
const sendMessage = async (messageData, token) => {
    try {
        const response = await messaging.sendToDevice(token, messageData);
        console.log('Successfully sent message:', response);
    } catch (error) {
        console.log('Error sending message:', error);
    }
}

export { messaging as default, sendMessage };
