import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medicine_info_state.dart';

class MedicineInfoCubit extends Cubit<MedicineInfoState> {
  MedicineInfoCubit({Medication? medication})
    : super(
        medication != null
            ? MedicineInfoState.fromMedication(medication)
            : MedicineInfoState.initial(),
      );

  void toggleMedicineTaken(bool value) {
    emit(
      state.copyWith(medication: state.medication.copyWith(isActive: value)),
    );
  }

  void toggleCriticalMode(bool value) {
    emit(
      state.copyWith(
        medication: state.medication.copyWith(isCriticalMode: value),
      ),
    );
  }

  void refillStock({required int amount}) {
    final updatedStock = state.stock + amount;
    emit(
      state.copyWith(
        medication: state.medication.copyWith(
          stock: updatedStock,
          currentStock: updatedStock.toString(),
        ),
      ),
    );
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

  void deleteMedication() {
    emit(state.copyWith(isDeleted: true));
  }
}
