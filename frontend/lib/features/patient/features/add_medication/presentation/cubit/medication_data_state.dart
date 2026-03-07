import 'package:medi/features/patient/features/add_medication/presentation/models/medication_data.dart';

abstract class MedicationDataState {
  final MedicationData medicationData;

  const MedicationDataState({required this.medicationData});
}

class MedicationDataInitial extends MedicationDataState {
  const MedicationDataInitial()
      : super(
          medicationData: const MedicationData(
            selectedMethod: 0,
            medicationName: '',
            type: '',
            dosage: '',
            frequency: '',
            startDate: '',
            endDate: '',
            reminders: [],
            currentStock: '',
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
