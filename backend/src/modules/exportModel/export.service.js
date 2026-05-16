import PDFDocument from 'pdfkit';
import QRCode from 'qrcode';
import jwt from 'jsonwebtoken';
import userModel from '../../models/user.model.js';
import patientModel from '../../models/patient.model.js';
import doctorModel from '../../models/doctor.model.js';
import healthMeasurementModel from '../../models/health-measurement.model.js';
import * as ET from '../../utils/encryption/index.js';

// Helper to fetch patient data securely
const fetchPatientData = async (patientIdFromReq, userId, userRole) => {
    let patient;
    if (userRole === 'doctor') {
        if (!patientIdFromReq) throw { status: 400, message: 'Patient ID is required for doctors' };

        const doctor = await doctorModel.findOne({ userId });
        if (!doctor) throw { status: 403, message: 'Doctor profile not found' };

        const isConnected = doctor.connectedPatients?.some(
            c => String(c.patientId) === String(patientIdFromReq) && c.status === 'approved'
        );

        if (!isConnected) throw { status: 403, message: 'You do not have an approved connection with this patient' };

        patient = await patientModel.findById(patientIdFromReq)
            .populate('userId')
            .populate('medications')
            .populate('longTermMedication')
            .lean();
    } else {
        patient = await patientModel.findOne({ userId })
            .populate('userId')
            .populate('medications')
            .populate('longTermMedication')
            .lean();
    }

    if (!patient) throw { status: 404, message: 'Patient not found' };

    if (patient.userId && patient.userId.phone) {
        try { patient.userId.phone = await ET.decrypt(patient.userId.phone); } catch (e) { }
    }

    return patient;
};

// Generate Health Passport PDF
export const generateHealthPassport = async (req, res) => {
    try {
        const { role, id: userId } = req.user;
        const patientIdFromReq = req.query.patientId;

        const patient = await fetchPatientData(patientIdFromReq, userId, role);

        // Build PDF
        const doc = new PDFDocument({ margin: 50, size: 'A4' });

        res.setHeader('Content-Type', 'application/pdf');
        res.setHeader('Content-Disposition', `attachment; filename=Health_Passport_${patient.userId.firstName}.pdf`);
        doc.pipe(res);

        // Header
        doc.fontSize(24).fillColor('#2c3e50').text('MediApp Health Passport', { align: 'center' });
        doc.moveDown();

        // Basic Info
        doc.fontSize(16).fillColor('#34495e').text('Patient Information', { underline: true });
        doc.fontSize(12).fillColor('#000').moveDown(0.5);
        doc.text(`Name: ${patient.userId.firstName} ${patient.userId.lastName}`);
        doc.text(`Email: ${patient.userId.email}`);
        doc.text(`Age: ${patient.userId.age || 'N/A'}`);
        doc.text(`Blood Type: ${patient.bloodTypes || 'Unknown'}`);
        doc.moveDown();

        // Chronic Conditions
        doc.fontSize(16).fillColor('#34495e').text('Chronic Conditions', { underline: true }).moveDown(0.5);
        doc.fontSize(12).fillColor('#000');
        if (patient.chronicConditions?.length > 0) {
            patient.chronicConditions.forEach(c => doc.text(`• ${c}`));
        } else {
            doc.text('None recorded.');
        }
        doc.moveDown();

        // Allergies
        doc.fontSize(16).fillColor('#34495e').text('Allergies', { underline: true }).moveDown(0.5);
        doc.fontSize(12).fillColor('#000');
        if (patient.allergies?.length > 0) {
            patient.allergies.forEach(a => doc.text(`• ${a}`));
        } else {
            doc.text('None recorded.');
        }

        doc.end();

    } catch (error) {
        res.status(error.status || 500).json({ message: error.message || 'Internal Server Error' });
    }
};

// Generate Comprehensive Patient Record PDF
export const generatePatientRecord = async (req, res) => {
    try {
        const { role, id: userId } = req.user;
        const patientIdFromReq = req.query.patientId;

        const patient = await fetchPatientData(patientIdFromReq, userId, role);
        const measurements = await healthMeasurementModel.find({ patientId: patient._id }).sort({ date: -1 }).limit(20).lean();

        const doc = new PDFDocument({ margin: 50, size: 'A4' });

        res.setHeader('Content-Type', 'application/pdf');
        res.setHeader('Content-Disposition', `attachment; filename=Patient_Record_${patient.userId.firstName}.pdf`);
        doc.pipe(res);

        // Header
        doc.fontSize(24).fillColor('#2c3e50').text('Comprehensive Patient Record', { align: 'center' });
        doc.moveDown();

        // Basic Info
        doc.fontSize(14).text(`Name: ${patient.userId.firstName} ${patient.userId.lastName}`);
        doc.text(`Date of Birth: ${patient.userId.DOB ? new Date(patient.userId.DOB).toLocaleDateString() : 'N/A'}`);
        doc.moveDown();

        // Medications
        doc.fontSize(16).fillColor('#34495e').text('Current Medications', { underline: true }).moveDown(0.5);
        doc.fontSize(12).fillColor('#000');
        if (patient.medications?.length > 0) {
            patient.medications.forEach(m => {
                doc.text(`• ${m.name || m.activeIngredient} - ${m.dosage || 'N/A'} (${m.frequency})`);
            });
        } else {
            doc.text('No active medications.');
        }
        doc.moveDown();

        // Recent Measurements
        doc.fontSize(16).fillColor('#34495e').text('Recent Health Measurements', { underline: true }).moveDown(0.5);
        doc.fontSize(12).fillColor('#000');
        if (measurements.length > 0) {
            measurements.forEach(m => {
                const date = new Date(m.date).toLocaleDateString();
                if (m.type === 'blood_pressure') {
                    doc.text(`• [${date}] Blood Pressure: ${m.systolic}/${m.diastolic} mmHg`);
                } else {
                    doc.text(`• [${date}] ${m.type}: ${m.value}`);
                }
            });
        } else {
            doc.text('No recent measurements.');
        }

        doc.end();

    } catch (error) {
        res.status(error.status || 500).json({ message: error.message || 'Internal Server Error' });
    }
};

// Generate QR Token
export const generateQRToken = async (req, res) => {
    try {
        const userId = req.user.id;
        const patient = await patientModel.findOne({ userId });
        if (!patient) return res.status(404).json({ message: 'Patient not found' });

        // Create a JWT valid for 24 hours
        const qrToken = jwt.sign(
            { patientId: patient._id },
            process.env.JWT_SECRET || 'fallback_secret',
            { expiresIn: '24h' }
        );

        const baseUrl = process.env.APP_BASE_URL || process.env.BASE_URL || 'http://localhost:8000';
        const shareUrl = `${baseUrl}/export/shared/${qrToken}`;
        const qrCodeBase64 = await QRCode.toDataURL(shareUrl);

        return res.status(200).json({
            message: 'QR Token generated',
            qrToken,
            shareUrl,
            qrCodeBase64
        });

    } catch (error) {
        return res.status(500).json({ message: 'Error generating QR token' });
    }
};

// Access Shared Record via QR token
export const getSharedRecord = async (req, res) => {
    try {
        const { qrToken } = req.params;
        const decoded = jwt.verify(qrToken, process.env.JWT_SECRET || 'fallback_secret');

        const patient = await patientModel.findById(decoded.patientId)
            .populate('userId', 'firstName lastName age bloodTypes email phone')
            .lean();

        if (!patient) return res.status(404).json({ message: 'Patient not found' });

        // Build PDF
        const doc = new PDFDocument({ margin: 50, size: 'A4' });

        res.setHeader('Content-Type', 'application/pdf');
        res.setHeader('Content-Disposition', `attachment; filename=Health_Passport_${patient.userId.firstName}.pdf`);
        doc.pipe(res);

        // Header
        doc.fontSize(24).fillColor('#2c3e50').text('MediApp Health Passport', { align: 'center' });
        doc.moveDown();

        // Basic Info
        doc.fontSize(16).fillColor('#34495e').text('Patient Information', { underline: true });
        doc.fontSize(12).fillColor('#000').moveDown(0.5);
        doc.text(`Name: ${patient.userId.firstName} ${patient.userId.lastName}`);
        doc.text(`Email: ${patient.userId.email}`);
        doc.text(`Age: ${patient.userId.age || 'N/A'}`);
        doc.text(`Blood Type: ${patient.bloodTypes || 'Unknown'}`);
        doc.moveDown();

        // Chronic Conditions
        doc.fontSize(16).fillColor('#34495e').text('Chronic Conditions', { underline: true }).moveDown(0.5);
        doc.fontSize(12).fillColor('#000');
        if (patient.chronicConditions?.length > 0) {
            patient.chronicConditions.forEach(c => doc.text(`• ${c}`));
        } else {
            doc.text('None recorded.');
        }
        doc.moveDown();

        // Allergies
        doc.fontSize(16).fillColor('#34495e').text('Allergies', { underline: true }).moveDown(0.5);
        doc.fontSize(12).fillColor('#000');
        if (patient.allergies?.length > 0) {
            patient.allergies.forEach(a => doc.text(`• ${a}`));
        } else {
            doc.text('None recorded.');
        }

        doc.end();
    } catch (error) {
        return res.status(401).json({ message: 'Invalid or expired QR token' });
    }
};
