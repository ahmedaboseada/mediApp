import 'package:flutter/material.dart';

enum SubmitStatus { idle, loading, success, error }

class ScheduleAppointmentsState {
  final List<String> workingDays;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final int? consultationDuration;
  final List<String> appointmentTypes;
  final int? maxDailyPatients;

  final SubmitStatus status;
  final String? errorMessage;

  const ScheduleAppointmentsState({
    this.workingDays = const [],
    this.startTime,
    this.endTime,
    this.consultationDuration,
    this.appointmentTypes = const [],
    this.maxDailyPatients,
    this.status = SubmitStatus.idle,
    this.errorMessage,
  });

  bool get isLoading => status == SubmitStatus.loading;
  bool get isSuccess => status == SubmitStatus.success;
  bool get isError => status == SubmitStatus.error;

  ScheduleAppointmentsState copyWith({
    List<String>? workingDays,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    int? consultationDuration,
    List<String>? appointmentTypes,
    int? maxDailyPatients,
    SubmitStatus? status,
    String? errorMessage,
  }) {
    return ScheduleAppointmentsState(
      workingDays: workingDays ?? this.workingDays,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      consultationDuration: consultationDuration ?? this.consultationDuration,
      appointmentTypes: appointmentTypes ?? this.appointmentTypes,
      maxDailyPatients: maxDailyPatients ?? this.maxDailyPatients,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
