import express from 'express';
import { verifyToken } from '../../middlewares/authentication.js';
import { applyCaregiverContext } from '../../middlewares/caregiverContext.js';
import { restrictTo } from '../../middlewares/restrictTo.js';
import * as exportController from './export.controller.js';

const router = express.Router();

router.get('/health-passport', verifyToken, applyCaregiverContext, restrictTo(['patient', 'doctor']), exportController.generateHealthPassport);
router.get('/patient-record', verifyToken, applyCaregiverContext, restrictTo(['patient', 'doctor']), exportController.generatePatientRecord);
router.post('/qr-token', verifyToken, applyCaregiverContext, restrictTo(['patient']), exportController.generateQRToken);
router.post('/qr-token/report', verifyToken, applyCaregiverContext, restrictTo(['patient']), exportController.generateReportQRToken);

// Public route that the QR code actually points to
router.get('/shared/:qrToken', exportController.getSharedRecord);
router.get('/shared/report/:qrToken', exportController.getSharedReport);

export default router;
