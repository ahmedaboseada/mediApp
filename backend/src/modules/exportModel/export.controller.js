import * as exportService from './export.service.js';

export const generateHealthPassport = async (req, res, next) => {
    try {
        await exportService.generateHealthPassport(req, res);
    } catch (err) {
        next(err);
    }
};

export const generatePatientRecord = async (req, res, next) => {
    try {
        await exportService.generatePatientRecord(req, res);
    } catch (err) {
        next(err);
    }
};

export const generateQRToken = async (req, res, next) => {
    try {
        await exportService.generateQRToken(req, res);
    } catch (err) {
        next(err);
    }
};

export const generateReportQRToken = async (req, res, next) => {
    try {
        await exportService.generateReportQRToken(req, res);
    } catch (err) {
        next(err);
    }
};

export const getSharedRecord = async (req, res, next) => {
    try {
        await exportService.getSharedRecord(req, res);
    } catch (err) {
        next(err);
    }
};

export const getSharedReport = async (req, res, next) => {
    try {
        await exportService.getSharedReport(req, res);
    } catch (err) {
        next(err);
    }
};
