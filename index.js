// import { bootstrap } from './src/app.controller.js';

// bootstrap();

// nodemon --env-file=.env index.js

import express from "express";
import dotenv from "dotenv";
import cors from "cors";
import morgan from "morgan";
// Routes
import authRoutes from "./src/modules/auth/auth.controller.js";
// (بعدين هتضيف باقي الموديولات هنا)

dotenv.config();
const app = express();

// Middlewares
app.use(express.json());
app.use(cors());
if (process.env.NODE_ENV === "development") {
    app.use(morgan("dev"));
}

// Routes
app.use("/api/v1/auth", authRoutes);

// Health check route
app.get("/api/health", (req, res) => {
    res.json({ status: "OK", timestamp: new Date() });
});

// Error handler
app.use((err, req, res, next) => {
    console.error("Error:", err.message);
    res.status(500).json({ error: err.message });
});

import connectDB from "./src/config/DB.js";
dotenv.config();

const PORT = process.env.PORT || 5000;
connectDB();

app.listen(PORT, () => {
    console.log(`🚀 Server running in ${process.env.NODE_ENV} mode on port ${PORT}`);
});

