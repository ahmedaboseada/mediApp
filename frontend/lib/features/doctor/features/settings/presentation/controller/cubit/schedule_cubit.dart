import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/doctor/features/settings/domain/entities/schedule_entity.dart';
import 'package:meta/meta.dart';

part 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  ScheduleCubit()
    : super(
        ScheduleState(ScheduleEntity(workingDays: [], appointmentTypes: [])),
      );
  void updateWorkingDays(List<String> days) {
    final currentDays = state.schedule.workingDays;
    final newDays = List<String>.from(currentDays);
    for (var day in days) {
      if (newDays.contains(day)) {
        newDays.remove(day);
      } else {
        newDays.add(day);
      }
    }
    emit(
      state.copyWith(schedule: state.schedule.copyWith(workingDays: newDays)),
    );
  }

  void updateStartTime(String time) {
    emit(state.copyWith(schedule: state.schedule.copyWith(startTime: time)));
  }

  void updateEndTime(String time) {
    emit(state.copyWith(schedule: state.schedule.copyWith(endTime: time)));
  }

  void updateConsultationDuration(String duration) {
    emit(
      state.copyWith(
        schedule: state.schedule.copyWith(consultationDuration: duration),
      ),
    );
  }

  void updateAppointmentTypes(List<String> types) {
    emit(
      state.copyWith(
        schedule: state.schedule.copyWith(appointmentTypes: types),
      ),
    );
  }

  void updateMaxPatients(int max) {
    emit(state.copyWith(schedule: state.schedule.copyWith(maxPatients: max)));
  }
}
