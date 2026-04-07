import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medicine_state.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';
import 'package:medi/features/patient/features/add_medication/data/repo/medicine_repo.dart';

class MedicineCubit extends Cubit<MedicineState> {
  MedicineCubit(this._medicineRepo)
    : super(MedicineState.initial(const <Medication>[]));

  final MedicineRepo _medicineRepo;
  List<Medication> _allMedications = const <Medication>[];
  List<Medication> _activeMedications = const <Medication>[];

  int get allCount => _allMedications.length;

  int get activeCount => _activeMedications.isNotEmpty
      ? _activeMedications.length
      : _allMedications.where(_isMedicationActive).length;

  int get chronicCount => _allMedications.where((m) => m.isChronic).length;

  Future<void> loadMedications() async {
    final result = await _medicineRepo.getAllMedications();
    final medications = result.fold(
      (_) => HiveService.getMedications(),
      (items) => items,
    );
    _allMedications = medications;

    if (state.selectedTab == MedicineTab.active) {
      await loadActiveMedications();
      return;
    }

    emit(state.copyWith(medications: _filterList(_allMedications)));
  }

  Future<void> loadActiveMedications() async {
    final result = await _medicineRepo.getActiveMedications();
    final medications = result.fold(
      (_) => _allMedications.where(_isMedicationActive).toList(),
      (items) => items,
    );

    _activeMedications = medications;
    emit(state.copyWith(medications: medications));
  }

  Future<Either<ApiError, String>> addMedication(Medication medication) async {
    final result = await _medicineRepo.addMedicineFromMedication(medication);
    if (result.isRight()) {
      await HiveService.addMedication(medication);
      await loadMedications();
    }
    return result;
  }

  void changeTab(MedicineTab tab) {
    emit(state.copyWith(selectedTab: tab));

    if (tab == MedicineTab.active) {
      loadActiveMedications();
      return;
    }

    filterMedications();
  }

  void toggleFabMenu() {
    emit(state.copyWith(isFabExpanded: !state.isFabExpanded));
  }

  void filterMedications() {
    emit(state.copyWith(medications: _filterList(_allMedications)));
  }

  List<Medication> _filterList(List<Medication> all) {
    return _filterByTab(all, state.selectedTab);
  }

  static List<Medication> _filterByTab(List<Medication> all, MedicineTab tab) {
    return switch (tab) {
      MedicineTab.all => all,
      MedicineTab.active => all.where(_isMedicationActive).toList(),
      MedicineTab.chronic => all.where((m) => m.isChronic).toList(),
    };
  }

  static bool _isMedicationActive(Medication medication) {
    return medication.isActive;
  }
}
