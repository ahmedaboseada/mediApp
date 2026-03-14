import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medicine_state.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';

class MedicineCubit extends Cubit<MedicineState> {
  MedicineCubit() : super(MedicineState.initial(_mockMedications));

  static const List<Medication> _mockMedications = [
    Medication(
      name: 'Aspirin',
      type: 'Tablet',
      dosage: '100mg',
      schedule: 'Once daily',
      stock: 3,
      expiryDate: '12/31/2026',
      stockStatus: MedicationStockStatus.low,
      isCritical: false,
      isActive: true,
      isChronic: false,
      medicationType: MedicationType.tablet,
    ),
    Medication(
      name: 'Insulin',
      type: 'Injection',
      dosage: '10 units',
      schedule: 'Twice daily',
      stock: 15,
      expiryDate: '1/31/2026',
      stockStatus: MedicationStockStatus.medium,
      isCritical: true,
      isActive: true,
      isChronic: true,
      medicationType: MedicationType.syringe,
    ),
    Medication(
      name: 'Paracetamol',
      type: 'Capsule',
      dosage: '50mg',
      schedule: 'Once daily',
      stock: 28,
      expiryDate: '11/31/2026',
      stockStatus: MedicationStockStatus.good,
      isCritical: false,
      isActive: false,
      isChronic: true,
      medicationType: MedicationType.pill,
    ),
    Medication(
      name: 'Metformin',
      type: 'Tablet',
      dosage: '200mg',
      schedule: 'Once daily',
      stock: 45,
      expiryDate: '7/31/2026',
      stockStatus: MedicationStockStatus.good,
      isCritical: false,
      isActive: false,
      isChronic: true,
      medicationType: MedicationType.tablet,
    ),
  ];

  int get allCount => _mockMedications.length;

  int get activeCount =>
      _mockMedications.where((medication) => medication.isActive).length;

  int get chronicCount =>
      _mockMedications.where((medication) => medication.isChronic).length;

  void changeTab(MedicineTab tab) {
    emit(state.copyWith(selectedTab: tab));
    filterMedications();
  }

  void toggleFabMenu() {
    emit(state.copyWith(isFabExpanded: !state.isFabExpanded));
  }

  void filterMedications() {
    final filtered = switch (state.selectedTab) {
      MedicineTab.all => _mockMedications,
      MedicineTab.active =>
        _mockMedications.where((medication) => medication.isActive).toList(),
      MedicineTab.chronic =>
        _mockMedications.where((medication) => medication.isChronic).toList(),
    };

    emit(state.copyWith(medications: filtered));
  }
}
