import 'package:medi/features/doctor/features/patients/data/models/patient_data.dart';

enum PatientsStatus { initial, loading, success, empty, failure }

class PatientsState {
  const PatientsState({
    this.patients = const [],
    this.filteredPatients = const [],
    this.status = PatientsStatus.initial,
    this.errorMessage,
    this.searchQuery = '',
  });

  final List<PatientData> patients;
  final List<PatientData> filteredPatients;
  final PatientsStatus status;
  final String? errorMessage;
  final String searchQuery;

  List<PatientData> get displayedPatients =>
      searchQuery.isEmpty ? patients : filteredPatients;

  PatientsState copyWith({
    List<PatientData>? patients,
    List<PatientData>? filteredPatients,
    PatientsStatus? status,
    String? errorMessage,
    String? searchQuery,
    bool clearError = false,
  }) {
    return PatientsState(
      patients: patients ?? this.patients,
      filteredPatients: filteredPatients ?? this.filteredPatients,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
