import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/doctor/features/complete_profile/data/repo/doctor_complete_profile_repo.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/controller/schedule_appointments/schedule_appointments_state.dart';

class ScheduleAppointmentsCubit extends Cubit<ScheduleAppointmentsState> {
  ScheduleAppointmentsCubit(this._repo)
    : super(const ScheduleAppointmentsState());

  final DoctorCompleteProfileRepo _repo;

  void updateWorkingDays(List<String> days) {
    emit(state.copyWith(workingDays: days));
  }

  void updateStartTime(TimeOfDay time) {
    emit(state.copyWith(startTime: time));
  }

  void updateEndTime(TimeOfDay time) {
    emit(state.copyWith(endTime: time));
  }

  void updateConsultationDuration(String duration) {
    final durationInt = int.tryParse(duration.split(' ')[0]) ?? 0;
    emit(state.copyWith(consultationDuration: durationInt));
  }

  void updateAppointmentTypes(List<String> types) {
    emit(state.copyWith(appointmentTypes: types));
  }

  void updateMaxDailyPatients(String maxPatients) {
    final maxInt = int.tryParse(maxPatients) ?? 0;
    emit(state.copyWith(maxDailyPatients: maxInt));
  }

  bool _validateForm() {
    emit(state.copyWith(showFieldErrors: true));

    if (state.workingDays.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: 'Please select working days',
          clearError: false,
        ),
      );
      return false;
    }

    if (state.startTime == null) {
      emit(
        state.copyWith(
          errorMessage: 'Please select start time',
          clearError: false,
        ),
      );
      return false;
    }

    if (state.endTime == null) {
      emit(
        state.copyWith(
          errorMessage: 'Please select end time',
          clearError: false,
        ),
      );
      return false;
    }

    if (state.consultationDuration == null || state.consultationDuration == 0) {
      emit(
        state.copyWith(
          errorMessage: 'Please select consultation duration',
          clearError: false,
        ),
      );
      return false;
    }

    if (state.appointmentTypes.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: 'Please select appointment types',
          clearError: false,
        ),
      );
      return false;
    }

    if (state.maxDailyPatients == null || state.maxDailyPatients == 0) {
      emit(
        state.copyWith(
          errorMessage: 'Please enter max daily patients',
          clearError: false,
        ),
      );
      return false;
    }

    return true;
  }

  Future<void> submitScheduleAndAppointments() async {
    if (!_validateForm() || state.isSubmitting) {
      return;
    }

    emit(
      state.copyWith(
        isSubmitting: true,
        isSuccess: false,
        showFieldErrors: false,
        clearError: true,
      ),
    );

    final startHour =
        '${state.startTime!.hour.toString().padLeft(2, '0')}:${state.startTime!.minute.toString().padLeft(2, '0')}';
    final endHour =
        '${state.endTime!.hour.toString().padLeft(2, '0')}:${state.endTime!.minute.toString().padLeft(2, '0')}';

    // Call update schedule endpoint (unified)
    final result = await _repo.updateSchedule(
      workingDays: state.workingDays,
      startHour: startHour,
      endHour: endHour,
      consultationDuration: state.consultationDuration!,
      appointmentTypes: state.appointmentTypes,
      maxDailyPatients: state.maxDailyPatients!,
    );

    result.fold(
      (error) {
        emit(
          state.copyWith(
            isSubmitting: false,
            isSuccess: false,
            errorMessage: error.message,
          ),
        );
      },
      (message) {
        emit(state.copyWith(isSubmitting: false, isSuccess: true));
      },
    );
  }
}
