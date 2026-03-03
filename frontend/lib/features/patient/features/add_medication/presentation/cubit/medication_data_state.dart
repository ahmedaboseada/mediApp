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
    required MedicationData medicationData,
    required this.updateType,
  }) : super(medicationData: medicationData);
}

class MedicationDataLoading extends MedicationDataState {
  const MedicationDataLoading({required MedicationData medicationData})
      : super(medicationData: medicationData);
}

class MedicationDataError extends MedicationDataState {
  final String message;

  const MedicationDataError({
    required MedicationData medicationData,
    required this.message,
  }) : super(medicationData: medicationData);
}
