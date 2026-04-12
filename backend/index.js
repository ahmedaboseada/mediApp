import 'dotenv/config';
import { bootstrap } from './src/app.controller.js';
let appPromise = bootstrap();

export default async function handler(req, res) {
    const app = await appPromise;
    app(req, res);
}
