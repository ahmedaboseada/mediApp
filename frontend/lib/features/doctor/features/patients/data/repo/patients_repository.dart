import 'package:dartz/dartz.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/patients/data/models/patient_model.dart';

abstract class PatientsRepository {
  Future<Either<ApiError, List<PatientModel>>> getPatients({
    String? searchQuery,
  });

  // Future<Either<ApiError, PatientModel>> getPatientById(String id);

  Future<Either<ApiError, void>> sendAddRequest(String patientId);
}
