import express from 'express';
import { verifyToken } from '../../middlewares/authentication.js';
import { restrictTo } from '../../middlewares/restrictTo.js';
import * as exportController from './export.controller.js';

const router = express.Router();

router.get('/health-passport', verifyToken, restrictTo(['patient', 'doctor']), exportController.generateHealthPassport);
router.get('/patient-record', verifyToken, restrictTo(['patient', 'doctor']), exportController.generatePatientRecord);
router.post('/qr-token', verifyToken, restrictTo(['patient']), exportController.generateQRToken);

// Public route that the QR code actually points to
router.get('/shared/:qrToken', exportController.getSharedRecord);

export default router;
