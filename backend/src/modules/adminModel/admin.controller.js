import { Router } from 'express';
import { validation } from '../../middlewares/validation.js';
import { verifyToken } from '../../middlewares/authentication.js';
import { restrictTo } from '../../middlewares/restrictTo.js';

import * as AVS from './admin.validation.js';
import * as AS from './admin.service.js';

const adminRouter = Router();

adminRouter.use(verifyToken);
adminRouter.use(restrictTo(['admin']));

// Pending Doctors List
adminRouter.get('/doctors/pending', AS.getPendingDoctors);

// Approve/Reject Doctors
adminRouter.patch('/doctors/:id/approve', validation(AVS.doctorIdSchema), AS.approveDoctor);
adminRouter.patch('/doctors/:id/reject', validation(AVS.doctorIdSchema), AS.rejectDoctor);

export default adminRouter;
