// import { Router } from 'express';
// import { validation } from '../../middlewares/validation.js';
// import { verifyToken } from '../../middlewares/authentication.js';
// import { restrictTo } from '../../middlewares/restrictTo.js';

// import * as UVS from './user.validation.js';
// import * as US from './user.service.js';

// import messageRouter from '../messageModel/message.controller.js';

// // OPTIONAL: if you use cloudinary upload in signup/updateProfile
// // import { cloudinaryUploadAvatarAndCover } from '../../middlewares/cloudinary.js';
// // import { allowedFileExtensions } from '../../config/CONSTANTS.js';

// const userRouter = Router();
// console.log({
//     getProfileSchema: typeof UVS.getProfileSchema,
//     confirmEmailChangeSchema: typeof UVS.confirmEmailChangeSchema,
//     getProfileForAll: typeof US.getProfileForAll,
//     confirmEmailChange: typeof US.confirmEmailChange,
//     confirmEmail: typeof US.confirmEmail,
//     getProfile: typeof US.getProfile,
// });

// // nested
// userRouter.use('/:id/messages', messageRouter);

// // =======================
// // PUBLIC
// // =======================

// // If you need file upload for profilePicture in signup, use the spread version below:
// // userRouter.post(
// //   '/signup',
// //   ...cloudinaryUploadAvatarAndCover({ folder: 'users', customExtensions: [...allowedFileExtensions.image] }),
// //   validation(UVS.signupSchema),
// //   US.signup
// // );

// userRouter.post('/signup', validation(UVS.signupSchema), US.signup);
// userRouter.post('/signin', validation(UVS.signinSchema), US.signin);

// // refreshToken usually reads header auth; keep validation only if you validate headers
// userRouter.post('/refreshToken', US.refreshToken);

// // OTP login completion (2FA)
// userRouter.post('/signin/otp', validation(UVS.signinOtpSchema), US.signinWithOtp);

// // forgot password flow (if you still want these names)
// userRouter.post('/requestOTP', validation(UVS.requestOTPSchema), US.requestOTP);
// userRouter.post('/checkOTP', validation(UVS.checkOTPSchema), US.checkOTP);

// // email confirm flows
// userRouter.get('/confirmEmail/:token', US.confirmEmail);
// userRouter.get('/confirmEmailChange/:token', validation(UVS.confirmEmailChangeSchema), US.confirmEmailChange);

// // public profile by id
// userRouter.get('/profile/:id', validation(UVS.getProfileSchema), US.getProfileForAll);

// // =======================
// // PROTECTED
// // =======================
// userRouter.use(verifyToken);
// userRouter.use(restrictTo(['user', 'patient', 'doctor']));

// userRouter.post('/resendConfirmEmail', US.resendConfirmEmail);

// userRouter.get('/me', US.getProfile);
// userRouter.post('/logout', US.logout);

// // If updateProfile supports file upload, use spread version:
// // userRouter.patch(
// //   '/updateProfile',
// //   ...cloudinaryUploadAvatarAndCover({ folder: 'users', customExtensions: [...allowedFileExtensions.image] }),
// //   validation(UVS.updateProfileSchema),
// //   US.updateProfile
// // );
// userRouter.patch('/updateProfile', validation(UVS.updateProfileSchema), US.updateProfile);

// // email change
// userRouter.patch('/email/change', validation(UVS.changeEmailSchema), US.requestEmailChange);
// userRouter.patch('/email/cancel', US.cancelEmailChange);

// // 2FA toggle
// userRouter.patch('/2fa', validation(UVS.toggle2FASchema), US.toggle2FA);

// export default userRouter;



// import { Router } from 'express';
// import { validation } from '../../middlewares/validation.js';
// import { verifyToken } from '../../middlewares/authentication.js';
// import { restrictTo } from '../../middlewares/restrictTo.js';

// import * as UVS from './user.validation.js';
// import * as US from './user.service.js';

// import messageRouter from '../messageModel/message.controller.js';

// const userRouter = Router();

// userRouter.use('/:id/messages', messageRouter);

// // public
// userRouter.post('/signup', validation(UVS.signupSchema), US.signup);
// userRouter.post('/signin', validation(UVS.signinSchema), US.signin);
// userRouter.post('/refreshToken', validation(UVS.refreshTokenSchema), US.refreshToken);

// userRouter.post('/requestOTP', validation(UVS.requestOTPSchema), US.requestOTP);
// userRouter.post('/checkOTP', validation(UVS.checkOTPSchema), US.checkOTP);

// userRouter.get('/profile/:id', validation(UVS.getProfileSchema), US.getProfileForAll);

// userRouter.get('/confirmEmail/:token', US.confirmEmail);

// userRouter.post('/signin/otp', validation(UVS.signinOtpSchema), US.signinWithOtp);
// userRouter.get('/confirmEmailChange/:token', validation(UVS.confirmEmailChangeSchema), US.confirmEmailChange);

// // protected

// import { Router } from 'express';
// import { validation } from '../../middlewares/validation.js';
// import { verifyToken } from '../../middlewares/authentication.js';
// import { restrictTo } from '../../middlewares/restrictTo.js';

// import * as UVS from './user.validation.js';
// import * as US from './user.service.js';

// const userRouter = Router();

// // public
// userRouter.post('/signup', validation(UVS.signupSchema), US.signup);
// userRouter.post('/signin', validation(UVS.signinSchema), US.signin);
// userRouter.post('/signin/otp', validation(UVS.signinOtpSchema), US.signinWithOtp);

// userRouter.get('/confirmEmail/:token', US.confirmEmail);
// userRouter.get('/confirmEmailChange/:token', validation(UVS.confirmEmailChangeSchema), US.confirmEmailChange);

// userRouter.post('/refreshToken', US.refreshToken);

// // protected
// userRouter.use(verifyToken);
// userRouter.use(restrictTo(['user', 'patient', 'doctor']));

// userRouter.get('/me', US.getMe);
// userRouter.post('/logout', US.logout);

// userRouter.patch('/email/change', validation(UVS.changeEmailSchema), US.requestEmailChange);
// userRouter.patch('/email/cancel', US.cancelEmailChange);

// userRouter.patch('/2fa', validation(UVS.toggle2FASchema), US.toggle2FA);

// export default userRouter;

import { Router } from 'express';
import { validation } from '../../middlewares/validation.js';
import { verifyToken } from '../../middlewares/authentication.js';
import { restrictTo } from '../../middlewares/restrictTo.js';

import * as UVS from './user.validation.js';
import * as US from './user.service.js';

import messageRouter from '../messageModel/message.controller.js';

const userRouter = Router();

// Nested
userRouter.use('/:id/messages', messageRouter);

// =======================
// PUBLIC
// =======================
userRouter.post('/signup', validation(UVS.signupSchema), US.signup);
userRouter.post('/signin', validation(UVS.signinSchema), US.signin);
userRouter.post('/google', validation(UVS.googleAuthSchema), US.googleAuth);
userRouter.post('/signin/otp', validation(UVS.signinOtpSchema), US.signinWithOtp);

userRouter.get('/confirmEmail/:token', US.confirmEmail);
userRouter.get('/confirmEmailChange/:token', validation(UVS.confirmEmailChangeSchema), US.confirmEmailChange);

userRouter.post('/refreshToken', US.refreshToken);

// NEWLY UNCOMMENTED PUBLIC APIS:
// Not using validation schemas here since they do not exist in UVS currently
userRouter.post('/requestOTP', US.requestOTP);
userRouter.post('/checkOTP', US.checkOTP);

userRouter.post('/forgetPassword', validation(UVS.forgetPasswordSchema), US.forgetPassword);
userRouter.post('/forgetPassword/verify', validation(UVS.verifyForgetPasswordOTPSchema), US.verifyForgetPasswordOTP);
userRouter.post('/resetPassword', validation(UVS.resetPasswordSchema), US.resetPassword);
userRouter.get('/profile/:id', validation(UVS.getProfileSchema), US.getProfileForAll);

// =======================
// PROTECTED
// =======================
userRouter.use(verifyToken);
userRouter.use(restrictTo(['user', 'patient', 'doctor']));

userRouter.get('/me', US.getMe);
userRouter.post('/logout', US.logout);

userRouter.patch('/email/change', validation(UVS.changeEmailSchema), US.requestEmailChange);
userRouter.patch('/email/cancel', US.cancelEmailChange);

userRouter.patch('/2fa', validation(UVS.toggle2FASchema), US.toggle2FA);

// NEWLY UNCOMMENTED PROTECTED APIS:
userRouter.patch('/updateProfile', US.updateProfile);
userRouter.patch('/changePassword', validation(UVS.changePasswordSchema), US.changePassword);
userRouter.post('/resendConfirmEmail', US.resendConfirmEmail);

// SETTINGS
userRouter.patch('/settings', US.updateSettings);

// DELETE ACCOUNT
userRouter.delete('/me', US.deleteAccount);

export default userRouter;
