import { jest } from '@jest/globals';

// Mock models before importing service
jest.unstable_mockModule('../../models/index.js', () => ({
    patientModel: {
        findOne: jest.fn(),
        save: jest.fn()
    },
    medicineModel: {
        create: jest.fn(),
        find: jest.fn(),
        findOneAndUpdate: jest.fn(),
        findOneAndDelete: jest.fn(),
        findOne: jest.fn()
    }
}));

const models = await import('../../models/index.js');
const MS = await import('./medicine.service.js');

describe('Medicine Service', () => {
    let req, res, next;

    beforeEach(() => {
        req = {
            user: { id: 'user123' },
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

    it('should add a medicine', async () => {
        req.body = { name: 'Aspirin', type: 'tablet', frequency: 'daily' };

        const mockPatient = { _id: 'patient123', medications: { push: jest.fn() }, save: jest.fn() };
        models.patientModel.findOne.mockResolvedValue(mockPatient);

        const mockMedicine = { _id: 'med123', ...req.body };
        models.medicineModel.create.mockResolvedValue(mockMedicine);

        await MS.addMedicine(req, res, next);

        expect(models.patientModel.findOne).toHaveBeenCalledWith({ userId: 'user123' });
        expect(models.medicineModel.create).toHaveBeenCalledWith({ ...req.body, patientId: 'patient123', activeIngredient: 'Aspirin', sideEffects: [] });
        expect(mockPatient.medications.push).toHaveBeenCalledWith('med123');
        expect(mockPatient.save).toHaveBeenCalled();
        expect(res.status).toHaveBeenCalledWith(201);
        expect(res.json).toHaveBeenCalledWith({ message: 'Medicine added successfully', medicine: mockMedicine });
    });

    it('should get schedule for a day', async () => {
        const mockPatient = { _id: 'patient123' };
        models.patientModel.findOne.mockResolvedValue(mockPatient);

        const mockMed = {
            _id: 'med123',
            patientId: 'patient123',
            activeIngredient: 'Aspirin',
            criticalMode: true,
            type: 'tablet',
            dosage: '10mg',
            frequency: 'daily',
            daily: ['08:00', '20:00'],
            dates: []
        };
        models.medicineModel.find.mockResolvedValue([mockMed]);

        await MS.getSchedule(req, res, next);

        expect(res.status).toHaveBeenCalledWith(200);
        expect(res.json).toHaveBeenCalledTimes(1);

        const responseData = res.json.mock.calls[0][0];
        expect(responseData.schedule.length).toBe(1);
        expect(responseData.schedule[0].times.length).toBe(2);
        expect(responseData.schedule[0].times[0].time).toBe('08:00');
        expect(responseData.schedule[0].times[0].taken).toBe(false);
    });

    it('should mark medicine as taken', async () => {
        req.params = { id: 'med123' };
        req.body = { date: '2026-06-15', time: '08:00', taken: true };

        const mockPatient = { _id: 'patient123' };
        models.patientModel.findOne.mockResolvedValue(mockPatient);

        const mockMed = {
            _id: 'med123',
            patientId: 'patient123',
            stock: 5,
            leftThreshold: 10,
            dates: [],
            save: jest.fn()
        };
        models.medicineModel.findOne.mockResolvedValue(mockMed);

        await MS.markAsTaken(req, res, next);

        expect(mockMed.stock).toBe(4); // decreased because it was taken
        expect(mockMed.dates.length).toBe(1);
        expect(mockMed.dates[0].times[0].time).toBe('08:00');
        expect(mockMed.dates[0].times[0].taken).toBe(true);
        expect(mockMed.save).toHaveBeenCalled();

        expect(res.status).toHaveBeenCalledWith(200);
        expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
            restockAlert: true, // 4 <= 10
            currentStock: 4
        }));
    });
});
