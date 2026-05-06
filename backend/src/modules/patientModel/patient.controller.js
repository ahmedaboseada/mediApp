// import { Router } from 'express';
// import { verifyToken } from '../../middlewares/authentication.js';
// import { restrictTo } from '../../middlewares/restrictTo.js';
// import { validation } from '../../middlewares/validation.js';
// import * as PS from './patient.service.js';
// import * as PVS from './patient.validation.js';

// const patientRouter = Router();

// patientRouter.use(verifyToken);
// patientRouter.use(restrictTo(['patient', 'user', 'doctor'])); // keep your style; services enforce type

// patientRouter.patch('/complete-profile', validation(PVS.completeProfileSchema), PS.completeProfile);

// patientRouter.post('/caregiver/request', validation(PVS.requestCaregiverSchema), PS.requestCaregiver);

// // caregiver user sees pending requests
// patientRouter.get('/caregiver/requests', PS.listCaregiverRequests);

// patientRouter.patch(
//     '/caregiver/requests/:requestId/accept',
//     validation(PVS.requestIdSchema),
//     PS.acceptCaregiverRequest
// );

// patientRouter.patch(
//     '/caregiver/requests/:requestId/reject',
//     validation(PVS.requestIdSchema),
//     PS.rejectCaregiverRequest
// );

// export default patientRouter;

import { Router } from 'express';
import { validation } from '../../middlewares/validation.js';
import { verifyToken } from '../../middlewares/authentication.js';
import { restrictTo } from '../../middlewares/restrictTo.js';

import * as PVS from './patient.validation.js';
import * as PS from './patient.service.js';
import { cloudinaryUploadAvatarAndCover } from '../../middlewares/cloudinary.js';

const patientRouter = Router();

patientRouter.use(verifyToken);
patientRouter.use(restrictTo(['patient']));

// screens: complete profile (merged)
patientRouter.patch('/complete', ...cloudinaryUploadAvatarAndCover({ folder: 'patients' }), validation(PVS.completeProfileSchema), PS.completeProfile);

// screens: complete profile (individual)
patientRouter.patch('/complete/basic', ...cloudinaryUploadAvatarAndCover({ folder: 'patients' }), validation(PVS.completeBasicSchema), PS.completeBasic);
patientRouter.patch('/complete/health1', validation(PVS.completeHealth1Schema), PS.completeHealth1);
patientRouter.patch('/complete/health2', validation(PVS.completeHealth2Schema), PS.completeHealth2);

// caregiver mode
patientRouter.patch('/caregiver/option', validation(PVS.caregiverOptionSchema), PS.setCaregiverOption);
patientRouter.post('/caregiver/request', validation(PVS.caregiverRequestSchema), PS.requestCaregiver);

// caregiver inbox/accept/reject (caregiver user logs in; still must be patient type in your design)
// If caregiver can be any type, remove restrictTo(['patient']) and enforce inside service.
patientRouter.get('/caregiver/requests', PS.listCaregiverRequests);
patientRouter.patch('/caregiver/requests/:requestId/accept', validation(PVS.requestIdSchema), PS.acceptCaregiverRequest);
patientRouter.patch('/caregiver/requests/:requestId/cancel', validation(PVS.requestIdSchema), PS.cancelCaregiverRequest);
// doctor connections
patientRouter.post('/connect-doctor', validation(PVS.connectDoctorSchema), PS.connectDoctor);
patientRouter.get('/connected-doctors', PS.listConnectedDoctors);
patientRouter.get('/doctor-requests', PS.listDoctorRequests);
patientRouter.patch('/connected-doctors/accept/:doctorId', validation(PVS.doctorIdSchema), PS.acceptDoctor);
patientRouter.patch('/connected-doctors/reject/:doctorId', validation(PVS.doctorIdSchema), PS.rejectDoctor);
patientRouter.patch('/connected-doctors/cancel/:doctorId', validation(PVS.doctorIdSchema), PS.cancelDoctorRequest);

// SOS
patientRouter.patch('/emergency-contact', PS.setEmergencyContact);
patientRouter.post('/sos', PS.triggerSOS);

export default patientRouter;