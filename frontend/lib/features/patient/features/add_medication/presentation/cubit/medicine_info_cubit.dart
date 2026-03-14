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
    emit(state.copyWith(isTaken: value));
  }

  void toggleCriticalMode(bool value) {
    emit(state.copyWith(criticalMode: value));
  }

  void refillStock({int amount = 15}) {
    emit(state.copyWith(stock: state.stock + amount));
  }

  void addScheduleItem() {
    final item = ScheduleItem(
      id: 's${state.schedule.length + 1}',
      time: state.schedule.length.isEven ? '6:00 AM' : '9:00 PM',
      frequency: 'Daily',
      duration: 'Ongoing',
    );
    emit(state.copyWith(schedule: [...state.schedule, item]));
  }

  void deleteMedication() {
    emit(state.copyWith(isDeleted: true));
  }
}
