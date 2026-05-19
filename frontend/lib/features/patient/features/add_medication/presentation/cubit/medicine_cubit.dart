import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/services/hive_service.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medicine_state.dart';
import 'package:medi/features/patient/features/add_medication/data/repo/medicine_repo.dart';

class MedicineCubit extends Cubit<MedicineState> {
  MedicineCubit(this._medicineRepo)
    : super(MedicineState.initial(const <Medication>[]));

  final MedicineRepo _medicineRepo;

  List<Medication> _allMedications = [];
  //final List<Medication> _activeMedications = [];

  // =========================
  // LOAD MEDICATIONS (LOCAL FIRST)
  // =========================
  Future<void> loadMedications() async {
    emit(state.copyWith(isLoading: true));

    try {
      final isCaregiverMode = getIt<CaregiverModeCubit>().isManagingPatient;

      if (isCaregiverMode) {
        final managedProfile = getIt<ManagedPatientDashboardCubit>().state.profile;
        final managedMedications = managedProfile?.patient?.medications ?? const <Medication>[];
        _allMedications = managedMedications;

        emit(
          state.copyWith(
            medications: _filterByTab(managedMedications, state.selectedTab),
            isLoading: false,
          ),
        );

        _syncFromServerSilently();
        return;
      }

      // 1) ALWAYS load local first (instant UI)
      final localData = HiveService.getMedications();
      _allMedications = localData;

      emit(
        state.copyWith(
          medications: _filterByTab(localData, state.selectedTab),
          isLoading: false,
        ),
      );

      // 2) Try sync in background (non-blocking UI)
      _syncFromServerSilently();
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  // =========================
  // ADD MEDICATION (OFFLINE-FIRST)
  // =========================
  Future<void> addMedication(Medication medication) async {
    try {
      final isCaregiverMode = getIt<CaregiverModeCubit>().isManagingPatient;

      if (isCaregiverMode) {
        final result = await _medicineRepo.addMedicineFromMedication(medication);

        result.fold(
          (failure) => emit(state.copyWith(error: failure.message)),
          (_) {
            final updatedList = [..._allMedications, medication];
            _allMedications = updatedList;

            emit(
              state.copyWith(
                medications: _filterByTab(updatedList, state.selectedTab),
              ),
            );
          },
        );
        return;
      }

      // 1) UPDATE UI IMMEDIATELY (optimistic)
      final updatedList = [..._allMedications, medication];
      _allMedications = updatedList;

      emit(
        state.copyWith(
          medications: _filterByTab(updatedList, state.selectedTab),
        ),
      );

      // 2) SAVE LOCALLY + QUEUE SYNC
      await HiveService.addMedication(medication);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  // =========================
  // UPDATE MEDICATION
  // =========================
  Future<void> updateMedication({
    required Medication original,
    required Medication updated,
  }) async {
    try {
      final isCaregiverMode = getIt<CaregiverModeCubit>().isManagingPatient;

      if (isCaregiverMode) {
        final result = await _medicineRepo.updateMedicineFromMedication(
          medicationId: original.id,
          medication: updated,
        );

        result.fold(
          (failure) => emit(state.copyWith(error: failure.message)),
          (_) {
            final index = _allMedications.indexWhere((m) => m.id == original.id);
            if (index != -1) {
              _allMedications[index] = updated;
            }

            emit(
              state.copyWith(
                medications: _filterByTab(_allMedications, state.selectedTab),
              ),
            );
          },
        );
        return;
      }

      final index = _allMedications.indexOf(original);

      if (index != -1) {
        _allMedications[index] = updated;

        emit(
          state.copyWith(
            medications: _filterByTab(_allMedications, state.selectedTab),
          ),
        );
      }

      await HiveService.updateMedication(original: original, updated: updated);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  // =========================
  // DELETE MEDICATION
  // =========================
  Future<void> deleteMedication(Medication medication) async {
    try {
      final isCaregiverMode = getIt<CaregiverModeCubit>().isManagingPatient;

      if (isCaregiverMode) {
        final result = await _medicineRepo.deleteMedication(
          medicationId: medication.id,
        );

        result.fold(
          (failure) => emit(state.copyWith(error: failure.message)),
          (_) {
            _allMedications.removeWhere((m) => m.id == medication.id);
            emit(
              state.copyWith(
                medications: _filterByTab(_allMedications, state.selectedTab),
              ),
            );
          },
        );
        return;
      }

      _allMedications.removeWhere((m) => m.id == medication.id);

      emit(
        state.copyWith(
          medications: _filterByTab(_allMedications, state.selectedTab),
        ),
      );

      await HiveService.deleteMedication(medication);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  // =========================
  // SYNC FROM SERVER (BACKGROUND ONLY)
  // =========================
  Future<void> _syncFromServerSilently() async {
    try {
      final result = await _medicineRepo.getAllMedications();
      final isCaregiverMode = getIt<CaregiverModeCubit>().isManagingPatient;

      result.fold(
        (_) {}, // ignore errors silently
        (serverData) {
          _allMedications = serverData;

          emit(
            state.copyWith(
              medications: _filterByTab(serverData, state.selectedTab),
            ),
          );

          if (!isCaregiverMode) {
            // optional: update local cache
            HiveService.saveMedications(serverData);
          }
        },
      );
    } catch (_) {
      // ignore silently
    }
  }

  // =========================
  // TAB MANAGEMENT
  // =========================
  void changeTab(MedicineTab tab) {
    emit(state.copyWith(selectedTab: tab));

    emit(state.copyWith(medications: _filterByTab(_allMedications, tab)));
  }

  // =========================
  // FILTERING
  // =========================
  List<Medication> _filterByTab(List<Medication> all, MedicineTab tab) {
    switch (tab) {
      case MedicineTab.all:
        return all;

      case MedicineTab.active:
        return all.where((m) => m.isActive).toList();

      case MedicineTab.chronic:
        return all.where((m) => m.isChronic).toList();
    }
  }

  void toggleFabMenu() {
    emit(state.copyWith(isFabExpanded: !state.isFabExpanded));
  }

  Future<String> generateDoctorMedicationAccessToken() async {
    final result = await _medicineRepo.getDoctorMedicationAccessToken();

    return result.fold(
      (failure) => throw Exception(failure.message),
      (token) => token,
    );
  }

  // =========================
  // STATS
  // =========================
  int get allCount => _allMedications.length;

  int get activeCount => _allMedications.where((m) => m.isActive).length;

  int get chronicCount => _allMedications.where((m) => m.isChronic).length;
}
