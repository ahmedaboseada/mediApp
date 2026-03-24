import { Router } from 'express';
import { validation } from '../../middlewares/validation.js';
import { verifyToken } from '../../middlewares/authentication.js';
import { restrictTo } from '../../middlewares/restrictTo.js';

import * as MVS from './medicine.validation.js';
import * as MS from './medicine.service.js';

const medicineRouter = Router();

// all medicine routes require authentication and must be patient
medicineRouter.use(verifyToken);
medicineRouter.use(restrictTo(['patient']));

medicineRouter.post('/', validation(MVS.addMedicineSchema), MS.addMedicine);
medicineRouter.get('/', MS.getMedicines);
medicineRouter.get('/schedule', MS.getSchedule);
medicineRouter.put('/:id', validation(MVS.updateMedicineSchema), MS.updateMedicine);
medicineRouter.delete('/:id', validation(MVS.deleteMedicineSchema), MS.deleteMedicine);
medicineRouter.patch('/:id/taken', validation(MVS.markAsTakenSchema), MS.markAsTaken);
medicineRouter.post('/:id/log', validation(MVS.addLogSchema), MS.addLog);

export default medicineRouter;
