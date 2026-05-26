import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/complete_profile/data/repo/doctor_complete_profile_repo.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/controller/schedule_appointments/schedule_appointments_state.dart';
import 'package:medi/features/shared/auth/data/repo/auth_repo.dart';

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

  void updateConsultationDuration(String value) {
    final number = int.tryParse(value.split(' ').first) ?? 0;
    emit(state.copyWith(consultationDuration: number));
  }

  void updateAppointmentTypes(List<String> types) {
    emit(state.copyWith(appointmentTypes: types));
  }

  void updateMaxDailyPatients(String maxPatients) {
    final maxInt = int.tryParse(maxPatients) ?? 0;
    emit(state.copyWith(maxDailyPatients: maxInt));
  }

  TimeOfDay parseTime(String time) {
    final parts = time.split(":");
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Future<void> loadDoctorSchedule() async {
    emit(state.copyWith(status: SubmitStatus.loading));
    final repo = getIt<AuthRepo>();
    final result = await repo.getMe();

    result.fold(
      (error) {
        emit(
          state.copyWith(
            status: SubmitStatus.error,
            errorMessage: error.message,
          ),
        );
      },
      (doctor) {
        emit(
          state.copyWith(
            status: SubmitStatus.idle,
            workingDays: doctor.doctor!.workingDays,
            appointmentTypes: doctor.doctor!.appointmentTypes,
            consultationDuration: doctor.doctor!.consultationDuration,
            maxDailyPatients: doctor.doctor!.maxDailyPatients,
            startTime: parseTime(doctor.doctor!.workingHours.first.startHour),
            endTime: parseTime(doctor.doctor!.workingHours.first.endHour),
          ),
        );
      },
    );
  }

  //   void initFromDoctor(DoctorModel doctor) {
  //   emit(state.copyWith(
  //     workingDays: doctor.workingDays,
  //     appointmentTypes: doctor.appointmentTypes,
  //     consultationDuration: doctor.consultationDuration,
  //     maxDailyPatients: doctor.maxDailyPatients,
  //     startTime: doctor.workingHours?.isNotEmpty == true
  //         ? parseTime(doctor.workingHours.first.startHour)
  //         : null,
  //     endTime: doctor.workingHours?.isNotEmpty == true
  //         ? parseTime(doctor.workingHours.first.endHour)
  //         : null,
  //   ));
  // }

  String? _validate() {
    if (state.workingDays.isEmpty) return 'Select working days';
    if (state.startTime == null) return 'Select start time';
    if (state.endTime == null) return 'Select end time';
    if (state.consultationDuration == null) return 'Select duration';
    if (state.appointmentTypes.isEmpty) return 'Select appointment types';
    if (state.maxDailyPatients == null) return 'Enter max patients';
    return null;
  }

  String? _validateError() {
    if (state.workingDays.isEmpty) {
      return 'Please select working days';
    }

    if (state.startTime == null) {
      return 'Please select start time';
    }

    if (state.endTime == null) {
      return 'Please select end time';
    }

    if (state.consultationDuration == null || state.consultationDuration == 0) {
      return 'Please select consultation duration';
    }

    if (state.appointmentTypes.isEmpty) {
      return 'Please select appointment types';
    }

    if (state.maxDailyPatients == null || state.maxDailyPatients == 0) {
      return 'Please enter max daily patients';
    }

    return null;
  }

  Future<void> submitScheduleAndAppointments() async {
    final error = _validate();

    if (error != null) {
      emit(state.copyWith(status: SubmitStatus.error, errorMessage: error));
      return;
    }

    emit(state.copyWith(status: SubmitStatus.loading, errorMessage: null));

    final startHour =
        '${state.startTime!.hour.toString().padLeft(2, '0')}:${state.startTime!.minute.toString().padLeft(2, '0')}';

    final endHour =
        '${state.endTime!.hour.toString().padLeft(2, '0')}:${state.endTime!.minute.toString().padLeft(2, '0')}';

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
            status: SubmitStatus.error,
            errorMessage: error.message,
          ),
        );
      },
      (_) {
        emit(state.copyWith(status: SubmitStatus.success));

        // reset after success (optional)
        emit(state.copyWith(status: SubmitStatus.idle));
      },
    );
  }
}
