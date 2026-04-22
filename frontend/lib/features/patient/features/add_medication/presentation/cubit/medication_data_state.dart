import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';

abstract class MedicationDataState {
  final Medication medicationData;

  const MedicationDataState({required this.medicationData});
}

class MedicationDataInitial extends MedicationDataState {
  const MedicationDataInitial()
    : super(
        medicationData: const Medication(
          selectedMethod: 0,
          name: '',
          type: '',
          dosage: '',
          frequency: '',
          startDate: '',
          endDate: '',
          reminders: [],
          specificSchedule: [],
          stock: 0,
          expiryDate: '',
          isCriticalMode: false,
        ),
      );
}

class MedicationDataUpdated extends MedicationDataState {
  final String updateType; // For tracking what was updated

  const MedicationDataUpdated({
    required super.medicationData,
    required this.updateType,
  });
}

class MedicationDataLoading extends MedicationDataState {
  const MedicationDataLoading({required super.medicationData});
}

class MedicationDataError extends MedicationDataState {
  final String message;

  const MedicationDataError({
    required super.medicationData,
    required this.message,
  });
}
