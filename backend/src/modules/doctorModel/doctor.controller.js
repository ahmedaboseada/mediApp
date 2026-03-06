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
doctorRouter.use(restrictTo(['doctor']));

// screens: doctor onboarding
doctorRouter.patch('/complete/step1', ...cloudinaryUploadAvatarAndCover({ folder: 'doctors' }), validation(DVS.completeStep1Schema), DS.completeStep1);
doctorRouter.patch('/complete/location', validation(DVS.completeLocationSchema), DS.completeLocation);
doctorRouter.patch('/complete/schedule', validation(DVS.completeScheduleSchema), DS.completeSchedule);
doctorRouter.patch('/complete/appointments', validation(DVS.completeAppointmentsSchema), DS.completeAppointments);
doctorRouter.patch('/complete/license', validation(DVS.completeLicenseSchema), DS.completeLicense);

// single unified completion step
doctorRouter.patch('/complete', ...cloudinaryUploadAvatarAndCover({ folder: 'doctors' }), validation(DVS.completeProfileSchema), DS.completeProfile);

export default doctorRouter;