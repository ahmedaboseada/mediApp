import 'package:flutter/material.dart';

class ScheduleAppointmentsState {
  const ScheduleAppointmentsState({
    this.workingDays = const [],
    this.startTime,
    this.endTime,
    this.consultationDuration,
    this.appointmentTypes = const [],
    this.maxDailyPatients,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.showFieldErrors = false,
    this.errorMessage,
  });

  final List<String> workingDays;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final int? consultationDuration;
  final List<String> appointmentTypes;
  final int? maxDailyPatients;
  final bool isSubmitting;
  final bool isSuccess;
  final bool showFieldErrors;
  final String? errorMessage;

  ScheduleAppointmentsState copyWith({
    List<String>? workingDays,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    int? consultationDuration,
    List<String>? appointmentTypes,
    int? maxDailyPatients,
    bool? isSubmitting,
    bool? isSuccess,
    bool? showFieldErrors,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ScheduleAppointmentsState(
      workingDays: workingDays ?? this.workingDays,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      consultationDuration: consultationDuration ?? this.consultationDuration,
      appointmentTypes: appointmentTypes ?? this.appointmentTypes,
      maxDailyPatients: maxDailyPatients ?? this.maxDailyPatients,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      showFieldErrors: showFieldErrors ?? this.showFieldErrors,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
