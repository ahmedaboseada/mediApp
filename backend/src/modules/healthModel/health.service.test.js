import { jest } from '@jest/globals';

// Mock models before importing service
jest.unstable_mockModule('../../models/index.js', () => ({
    patientModel: {
        findOne: jest.fn()
    }
}));

jest.unstable_mockModule('../../models/health-measurement.model.js', () => ({
    default: {
        create: jest.fn(),
        find: jest.fn()
    }
}));

jest.unstable_mockModule('../../models/symptom-log.model.js', () => ({
    default: {
        create: jest.fn(),
        find: jest.fn()
    }
}));

const models = await import('../../models/index.js');
const HealthMeasurement = (await import('../../models/health-measurement.model.js')).default;
const SymptomLog = (await import('../../models/symptom-log.model.js')).default;
const HS = await import('./health.service.js');

describe('Health Service', () => {
    let req, res, next;

    beforeEach(() => {
        req = {
            user: { _id: 'user123' },
            body: {},
            query: {},
            params: {}
        };
        res = {
            status: jest.fn().mockReturnThis(),
            json: jest.fn()
        };
        next = jest.fn();
        jest.clearAllMocks();
    });

    it('should add a health measurement', async () => {
        req.body = { type: 'blood_pressure', systolic: 120, diastolic: 80 };

        models.patientModel.findOne.mockResolvedValue({ _id: 'patient123' });
        HealthMeasurement.create.mockResolvedValue({ ...req.body, _id: 'hm123' });

        await HS.addMeasurement(req, res, next);

        expect(HealthMeasurement.create).toHaveBeenCalledWith({ ...req.body, patientId: 'patient123' });
        expect(res.status).toHaveBeenCalledWith(201);
    });

    it('should fail to add blood pressure if missing values', async () => {
        req.body = { type: 'blood_pressure', systolic: 120 }; // missing diastolic

        models.patientModel.findOne.mockResolvedValue({ _id: 'patient123' });

        await HS.addMeasurement(req, res, next);

        expect(res.status).toHaveBeenCalledWith(400);
        expect(res.json).toHaveBeenCalledWith({ message: 'Systolic and diastolic values required for blood pressure' });
        expect(HealthMeasurement.create).not.toHaveBeenCalled();
    });

    it('should add a symptom log', async () => {
        req.body = { symptom: 'Headache', severity: 'moderate' };

        models.patientModel.findOne.mockResolvedValue({ _id: 'patient123' });
        SymptomLog.create.mockResolvedValue({ ...req.body, _id: 'sl123' });

        await HS.addSymptom(req, res, next);

        expect(SymptomLog.create).toHaveBeenCalledWith({ ...req.body, patientId: 'patient123' });
        expect(res.status).toHaveBeenCalledWith(201);
    });
});
