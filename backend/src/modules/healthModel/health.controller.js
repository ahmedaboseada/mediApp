import { Router } from 'express';
import { validation } from '../../middlewares/validation.js';
import { verifyToken } from '../../middlewares/authentication.js';
import { applyCaregiverContext } from '../../middlewares/caregiverContext.js';
import { restrictTo } from '../../middlewares/restrictTo.js';

import * as HVS from './health.validation.js';
import * as HS from './health.service.js';

const healthRouter = Router();

healthRouter.use(verifyToken, applyCaregiverContext);
healthRouter.use(restrictTo(['patient']));

healthRouter.post('/measurements', validation(HVS.addMeasurementSchema), HS.addMeasurement);
healthRouter.get('/measurements', HS.getMeasurements);

healthRouter.post('/symptoms', validation(HVS.addSymptomSchema), HS.addSymptom);
healthRouter.get('/symptoms', HS.getSymptoms);

export default healthRouter;
