export const userTypes = Object.freeze({
    user: 'user',
    patient: 'patient',
    doctor: 'doctor',
});

export const userGender = Object.freeze({
    male: 'male',
    female: 'female',
});

export const bloodTypes = Object.freeze({
    A_POS: 'A+',
    A_NEG: 'A-',
    B_POS: 'B+',
    B_NEG: 'B-',
    AB_POS: 'AB+',
    AB_NEG: 'AB-',
    O_POS: 'O+',
    O_NEG: 'O-',
});

export const contactMethods = Object.freeze({
    sms: 'sms',
    whatsapp: 'whatsapp',
});

export const weekDays = Object.freeze({
    sunday: 'sunday',
    monday: 'monday',
    tuesday: 'tuesday',
    wednesday: 'wednesday',
    thursday: 'thursday',
    friday: 'friday',
    saturday: 'saturday',
});

export const consultationDurations = Object.freeze({
    MIN_15: 15,
    MIN_30: 30,
    MIN_45: 45,
    MIN_60: 60,
});

export const appointmentTypes = Object.freeze({
    inPerson: 'in-person',
    online: 'online',
});

export const bookingStatus = Object.freeze({
    upcoming: 'upcoming',
    completed: 'completed',
    cancelled: 'cancelled',
});

export const messageStatus = Object.freeze({
    seen: 'seen',
    unseen: 'unseen',
});

export const chatStatus = Object.freeze({
    online: 'online',
    offline: 'offline',
});

export const medicineTypes = Object.freeze({
    tablet: 'tablet',
    capsule: 'capsule',
    syrup: 'syrup',
    injection: 'injection',
    drops: 'drops',
    spray: 'spray',
    cream: 'cream',
    other: 'other',
});

export const medicineFrequency = Object.freeze({
    daily: 'daily',
    weekly: 'weekly',
    specific: 'specific',
    asNeeded: 'as needed',
});

export const medicineStatus = Object.freeze({
    normal: 'normal',
    critical: 'critical',
});

export const feedbackLevels = Object.freeze({
    low: 'low',
    medium: 'medium',
    high: 'high',
});

export const notificationTypes = Object.freeze({
    medication: 'medication',
    refill: 'refill',
    critical: 'critical',
    missed: 'missed',
    bookingCancel: 'bookingCancel',
    bookingReschedule: 'bookingReschedule',
    healthUpdate: 'healthUpdate',
    healthAlert: 'healthAlert',
    doctorSessionStarted: 'doctorSessionStarted',
    doctorSessionEnded: 'doctorSessionEnded',
    doctorEarlyReminder: 'doctorEarlyReminder',
    doctorMediciationAddition: 'doctorMediciationAddition',
    doctorMediciationDeletion: 'doctorMediciationDeletion',
    doctorMedicationEdited: 'doctorMedicationEdited',
    doctorAdditionRequest: 'doctorAdditionRequest',
    doctorRequestAccepted: 'doctorRequestAccepted',
    doctorRequestRejected: 'doctorRequestRejected',
    caregiverMedication: 'caregiverMedication',
    caregiverRefill: 'caregiverRefill',
    caregiverCritical: 'caregiverCritical',
    caregiverMissed: 'caregiverMissed',
    caregiverHealthAlert: 'caregiverHealthAlert',
    caregiverRequestAccepted: 'caregiverRequestAccepted',
    caregiverRequestRejected: 'caregiverRequestRejected',
    chatMessage: 'chatMessage',
    patientAdditionRequest: 'patientAdditionRequest',
    patientRequestAccepted: 'patientRequestAccepted',
    patientRequestRejected: 'patientRequestRejected',
    doctorAdditionRequest: 'doctorAdditionRequest',
    doctorRequestAccepted: 'doctorRequestAccepted',
    doctorRequestRejected: 'doctorRequestRejected',
    systemNotification: 'systemNotification',
    appointmentReminder: 'appointmentReminder',
    appointmentRescheduled: 'appointmentRescheduled',
    appointmentCancelled: 'appointmentCancelled',
    appointmentCompleted: 'appointmentCompleted',
    patientAdded: 'patientAdded',
    patientRemoved: 'patientRemoved',
    doctorAdded: 'doctorAdded',
    doctorRemoved: 'doctorRemoved',
    caregiverAdded: 'caregiverAdded',
    caregiverRemoved: 'caregiverRemoved',
    patientUnblockRequest: 'patientUnblockRequest',
    patientUnblockRequestAccepted: 'patientUnblockRequestAccepted',
    patientUnblockRequestRejected: 'patientUnblockRequestRejected',
    doctorUnblockRequest: 'doctorUnblockRequest',
    doctorUnblockRequestAccepted: 'doctorUnblockRequestAccepted',
    doctorUnblockRequestRejected: 'doctorUnblockRequestRejected',
    caregiverUnblockRequest: 'caregiverUnblockRequest',
    caregiverUnblockRequestAccepted: 'caregiverUnblockRequestAccepted',
    caregiverUnblockRequestRejected: 'caregiverUnblockRequestRejected',

});
