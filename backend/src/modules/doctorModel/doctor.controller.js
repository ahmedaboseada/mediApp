// import { Router } from 'express';
// import { verifyToken } from '../../middlewares/authentication.js';
// import { restrictTo } from '../../middlewares/restrictTo.js';
// import { validation } from '../../middlewares/validation.js';
// import * as DS from './doctor.service.js';
// import * as DVS from './doctor.validation.js';

// const doctorRouter = Router();

// doctorRouter.use(verifyToken);
// doctorRouter.use(restrictTo(['doctor', 'user', 'patient'])); // services enforce type

// doctorRouter.patch('/complete-profile', validation(DVS.completeProfileSchema), DS.completeProfile);

// export default doctorRouter;
import { Router } from 'express';
import { validation } from '../../middlewares/validation.js';
import { verifyToken } from '../../middlewares/authentication.js';
import { restrictTo } from '../../middlewares/restrictTo.js';

import * as DVS from './doctor.validation.js';
import * as DS from './doctor.service.js';
import { cloudinaryUploadAvatarAndCover } from '../../middlewares/cloudinary.js';

const doctorRouter = Router();

doctorRouter.use(verifyToken);

// Directory is accessible to any verified user (patients looking for doctors)
doctorRouter.get('/directory', DS.getDoctorDirectory);

doctorRouter.use(restrictTo(['doctor']));

// screens: doctor onboarding
doctorRouter.patch('/complete/step1', ...cloudinaryUploadAvatarAndCover({ folder: 'doctors' }), validation(DVS.completeStep1Schema), DS.completeStep1);
doctorRouter.patch('/complete/location', validation(DVS.completeLocationSchema), DS.completeLocation);
doctorRouter.patch('/complete/schedule', validation(DVS.completeScheduleSchema), DS.completeSchedule);
doctorRouter.patch('/complete/appointments', validation(DVS.completeAppointmentsSchema), DS.completeAppointments);
doctorRouter.patch('/complete/license', ...cloudinaryUploadAvatarAndCover({ folder: 'doctors' }), validation(DVS.completeLicenseSchema), DS.completeLicense);

// single unified completion step
doctorRouter.patch('/complete', ...cloudinaryUploadAvatarAndCover({ folder: 'doctors' }), validation(DVS.completeProfileSchema), DS.completeProfile);

// screens: doctor schedule settings (post-onboarding update)
doctorRouter.patch('/schedule', validation(DVS.updateScheduleSchema), DS.updateSchedule);

// screens: patient connections & dashboard
doctorRouter.post('/patients/connect-patient', validation(DVS.patientIdBodySchema), DS.connectPatient);
doctorRouter.patch('/patients/accept/:patientId', validation(DVS.patientIdSchema), DS.acceptPatient);
doctorRouter.patch('/patients/reject/:patientId', validation(DVS.patientIdSchema), DS.rejectPatient);
doctorRouter.get('/patients', DS.listConnectedPatients);

export default doctorRouter;