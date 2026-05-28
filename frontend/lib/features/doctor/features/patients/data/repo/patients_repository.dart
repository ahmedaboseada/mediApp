import 'package:dartz/dartz.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/patients/data/models/patient_data.dart';

abstract class PatientsRepository {
  Future<Either<ApiError, List<PatientData>>> getPatients({
    String? searchQuery,
  });

  /// Return cached patients stored locally (may be empty).
  Future<List<PatientData>> getCachedPatients();

  // Future<Either<ApiError, PatientModel>> getPatientById(String id);

  Future<Either<ApiError, void>> sendAddRequest(String patientId);
  Future<Either<ApiError, void>> cancelPatientRequest(String patientId);
}
