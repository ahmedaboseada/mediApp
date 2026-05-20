import 'package:medi/features/doctor/features/home/data/models/doctor_appointment_model.dart';

enum AppointmentsStatus { initial, loading, success, empty, failure }

class AppointmentsState {
  const AppointmentsState({
    required this.selectedDate,
    this.appointments = const [],
    this.status = AppointmentsStatus.initial,
    this.errorMessage,
  });

  final DateTime selectedDate;
  final List<DoctorAppointmentModel> appointments;
  final AppointmentsStatus status;
  final String? errorMessage;

  AppointmentsState copyWith({
    DateTime? selectedDate,
    List<DoctorAppointmentModel>? appointments,
    AppointmentsStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AppointmentsState(
      selectedDate: selectedDate ?? this.selectedDate,
      appointments: appointments ?? this.appointments,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
