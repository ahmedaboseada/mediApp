import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medication_data_state.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';

class MedicationDataCubit extends Cubit<MedicationDataState> {
  MedicationDataCubit() : super(const MedicationDataInitial());

  // Initialize with existing medication data
  void initializeMedicationData(Medication medicationData) {
    emit(
      MedicationDataUpdated(
        medicationData: medicationData,
        updateType: 'initialize',
      ),
    );
  }

  // Update medication method
  void updateMethod(int method) {
    emit(
      MedicationDataUpdated(
        medicationData: state.medicationData.copyWith(selectedMethod: method),
        updateType: 'method',
      ),
    );
  }

  // Update medication details (name, type, dosage)
  void updateMedicationDetails({
    required String medicationName,
    required String type,
    required String dosage,
  }) {
    emit(
      MedicationDataUpdated(
        medicationData: state.medicationData.copyWith(
          medicationName: medicationName,
          type: type,
          dosage: dosage,
        ),
        updateType: 'details',
      ),
    );
  }

  // Update schedule and reminders
  void updateSchedule({
    required String frequency,
    required String startDate,
    required String endDate,
    required List<String> reminders,
  }) {
    emit(
      MedicationDataUpdated(
        medicationData: state.medicationData.copyWith(
          frequency: frequency,
          startDate: startDate,
          endDate: endDate,
          reminders: reminders,
        ),
        updateType: 'schedule',
      ),
    );
  }

  // Update stock and expiry
  void updateStockAndExpiry({
    required String currentStock,
    required String expiryDate,
    required bool isCriticalMode,
  }) {
    emit(
      MedicationDataUpdated(
        medicationData: state.medicationData.copyWith(
          currentStock: currentStock,
          expiryDate: expiryDate,
          isCriticalMode: isCriticalMode,
        ),
        updateType: 'stock',
      ),
    );
  }

  // Update a single field
  void updateField(String fieldName, dynamic value) {
    final updatedData = _updateField(state.medicationData, fieldName, value);
    emit(
      MedicationDataUpdated(medicationData: updatedData, updateType: fieldName),
    );
  }

  // Helper method to update a single field
  Medication _updateField(Medication data, String fieldName, dynamic value) {
    switch (fieldName) {
      case 'medicationName':
        return data.copyWith(medicationName: value as String);
      case 'type':
        return data.copyWith(type: value as String);
      case 'dosage':
        return data.copyWith(dosage: value as String);
      case 'frequency':
        return data.copyWith(frequency: value as String);
      case 'startDate':
        return data.copyWith(startDate: value as String);
      case 'endDate':
        return data.copyWith(endDate: value as String);
      case 'currentStock':
        return data.copyWith(currentStock: value as String);
      case 'expiryDate':
        return data.copyWith(expiryDate: value as String);
      case 'isCriticalMode':
        return data.copyWith(isCriticalMode: value as bool);
      case 'reminders':
        return data.copyWith(reminders: value as List<String>);
      default:
        return data;
    }
  }

  // Reset to initial state
  void reset() {
    emit(const MedicationDataInitial());
  }

  // Get current medication data
  Medication getMedicationData() => state.medicationData;
}
