import { Router } from 'express'
import * as AS from './auth.service.js'
import {cloudinaryUploadImage} from '../../middlewares/cloudinary.js'
import {verifyToken} from '../../middlewares/authentication.js'
const router = Router()

// router.post('/register', cloudinaryUploadImage({folder:"users",customExtensions:["png","jpg","jpeg"]}),AS.registerService)
router.post('/register', AS.registerService)
router.get('/confirmEmail/:token',AS.confirmEmailService)
router.use(verifyToken)
router.get('/resendConfirmEmail',AS.resendConfirmEmailService)
export default router