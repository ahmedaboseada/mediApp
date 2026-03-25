import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/services/hive_service.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medicine_info_state.dart';

class MedicineInfoCubit extends Cubit<MedicineInfoState> {
  late Medication _sourceMedication;

  MedicineInfoCubit({Medication? medication})
    : super(
        medication != null
            ? MedicineInfoState.fromMedication(medication)
            : MedicineInfoState.initial(),
      ) {
    _sourceMedication = medication ?? const Medication();
  }

  void toggleMedicineTaken(bool value) {
    emit(
      state.copyWith(medication: state.medication.copyWith(isActive: value)),
    );
  }

  void toggleCriticalMode(bool value) {
    final updated = state.medication.copyWith(isCriticalMode: value);
    emit(state.copyWith(medication: updated));
    _persistMedication(updated);
  }

  Future<void> refillStock({required int amount}) async {
    if (amount <= 0) return;
    final updatedStock = state.stock + amount;
    final updated = state.medication.copyWith(
      stock: updatedStock,
      currentStock: updatedStock.toString(),
      stockStatus: _statusForStock(updatedStock),
    );
    emit(state.copyWith(medication: updated));
    await _persistMedication(updated);
  }

  Future<void> _persistMedication(Medication updated) async {
    await HiveService.updateMedication(original: _sourceMedication, updated: updated);
    _sourceMedication = updated;
  }

  Future<void> applyEditedMedication(Medication updated) async {
    _sourceMedication = updated;
    emit(state.copyWith(medication: updated));
  }

  MedicationStockStatus _statusForStock(int stock) {
    if (stock <= 5 && stock > 0) return MedicationStockStatus.low;
    if (stock <= 20&& stock > 5) return MedicationStockStatus.medium;
    if (stock > 20) return MedicationStockStatus.good;
    return MedicationStockStatus.low;
  }

  void addScheduleItem() {
    final reminders = [...state.reminders];
    reminders.add(reminders.length.isEven ? '6:00 AM' : '9:00 PM');
    emit(
      state.copyWith(
        medication: state.medication.copyWith(reminders: reminders),
      ),
    );
  }

  Future<void> deleteMedication() async {
    await HiveService.deleteMedication(_sourceMedication);
    emit(state.copyWith(isDeleted: true));
      emit(state.copyWith(isDeleted: false));

  }
}
