import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/services/hive_service.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medicine_state.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';

class MedicineCubit extends Cubit<MedicineState> {
  MedicineCubit()
    : super(
        MedicineState.initial(_filterByTab(HiveService.getMedications(), MedicineTab.all)),
      );

  int get allCount => HiveService.getMedications().length;

  int get activeCount =>
      HiveService.getMedications().where(_isMedicationActive).length;

  int get chronicCount =>
      HiveService.getMedications().where((m) => m.isChronic).length;

  void loadMedications() {
    final all = HiveService.getMedications();
    emit(state.copyWith(medications: _filterList(all)));
  }

  Future<void> addMedication(Medication medication) async {
    await HiveService.addMedication(medication);
    loadMedications();
  }

  void changeTab(MedicineTab tab) {
    emit(state.copyWith(selectedTab: tab));
    filterMedications();
  }

  void toggleFabMenu() {
    emit(state.copyWith(isFabExpanded: !state.isFabExpanded));
  }

  void filterMedications() {
    final all = HiveService.getMedications();
    emit(state.copyWith(medications: _filterList(all)));
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
    final parts = medication.endDate.split('/');
    if (parts.length != 3) return false;

    final month = int.tryParse(parts[0]);
    final day = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (month == null || day == null || year == null) return false;

    DateTime endDate;
    try {
      endDate = DateTime(year, month, day);
    } catch (_) {
      return false;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return endDate.isAfter(today);
  }
}

