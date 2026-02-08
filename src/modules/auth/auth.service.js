import userModel from "../../models/user.model.js";
import * as utils from "../../utils/index.js";
import { eventEmitter } from "../../utils/sendEmail-events/index.js";
import jwt from "jsonwebtoken";
export const registerService = async (req, res) => {
    try {
        const { username, email, password, confirmPassword, phoneNumber = "", gender = "male" } = req.body;
        const secure_url = await req.file?.cloudinaryUrl;

        const existingUser = await userModel.findOne({
            $or: [{ email }, { username }]
        });
        if (existingUser) {
            return utils.RT.errorResponse(res, "User already exists", 400)
        }
        const hashedPassword = await utils.HT.hash({ plainText: password });
        const user = await userModel.create({
            username,
            email,
            password: hashedPassword,
            phoneNumber,
            // picture: secure_url,
            language: "en",
            gender
        })
        eventEmitter.emit("sendEmail", { email: user.email, name: user.username });
        return utils.RT.successResponse(res, "User registered successfully", user, 201)
    } catch (error) {
        return utils.RT.errorResponse(res, error.message, 500)
    }
}

export const confirmEmailService = async (req, res) => {
    try {
        const { token } = req.params;
        const decoded = await utils.VT.verifyConfirmEmailToken(token);
        const user = await userModel.findOne({ email: decoded.email });
        if (!user) {
            return utils.RT.errorResponse(res, "User not found", 404)
        }
        if (user.emailConfirmed) {
            return utils.RT.errorResponse(res, "Email already confirmed", 400)
        }
        user.emailConfirmed = true;
        await user.save();
        return utils.RT.successResponse(res, "Email confirmed successfully", user, 200)
    } catch (error) {
        return utils.RT.errorResponse(res, error.message, 500)
    }
}

export const resendConfirmEmailService = async (req, res) => {
    try {
        const { email } = req?.user?.email;
        const user = await userModel.findOne({ email });
        if (!user) {
            return utils.RT.errorResponse(res, "User not found", 404)
        }
        if (user.emailConfirmed) {
            return utils.RT.errorResponse(res, "Email already confirmed", 400)
        }
        eventEmitter.emit("sendEmail", { email: user.email, name: user.username });
        return utils.RT.successResponse(res, "Email sent successfully", user, 200)
    } catch (error) {
        return utils.RT.errorResponse(res, error.message, 500)
    }
}