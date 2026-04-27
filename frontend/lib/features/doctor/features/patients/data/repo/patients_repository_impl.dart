import 'package:dartz/dartz.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/patients/data/models/patient_data.dart';
import 'dart:developer';
import 'package:medi/features/doctor/features/patients/data/repo/patients_repository.dart';

class PatientsRepositoryImpl implements PatientsRepository {
  PatientsRepositoryImpl(this._apiService);

  final ApiService _apiService;
  // Mock data - replace with API calls when backend is ready

  @override
  Future<Either<ApiError, List<PatientData>>> getPatients({
    String? searchQuery,
  }) async {
    try {
      final response = await _apiService.get('/doctors/patients');

      if (response is ServerFailure) {
        return Left(response);
      }

      if (response is Map<String, dynamic> &&
          response.containsKey('patients')) {
        final List<dynamic> patientsData = response['patients'];
        List<PatientData> patients = patientsData
            .map((data) => PatientData.fromJson(data as Map<String, dynamic>))
            .toList();

        // Filter by search query if provided
        if (searchQuery != null && searchQuery.isNotEmpty) {
          final query = searchQuery.toLowerCase();
          patients = patients
              .where(
                (patient) =>
                    patient.name.toLowerCase().contains(query) ||
                    patient.id.toLowerCase().contains(query),
              )
              .toList();
        }
 log('Fetched patients: ${response['patients']}');
        return Right(patients);
      }

      return Left(ServerFailure('Unexpected response format'));
    } catch (e) {
      return Left(ServerFailure('Failed to fetch patients: ${e.toString()}'));
    }
  }

  @override
  // Future<Either<ApiError, PatientModel>> getPatientById(String id) async {
  //   try {
  //     // Simulate API delay
  //     await Future.delayed(const Duration(milliseconds: 600));
  //     return Right(patient);
  //   } on DioException catch (e) {
  //     return Left(ServerFailure('Failed to fetch patient: ${e.message}'));
  //   } catch (e) {
  //     return Left(ServerFailure('Patient not found'));
  //   }
  // }
  @override
  Future<Either<ApiError, void>> sendAddRequest(String patientId) async {
    try {
      final response = await _apiService.post(
        '/doctors/patients/connect-patient',
        {'patientId': patientId},
      );

      log('sendAddRequest response: $response');

      if (response is ServerFailure) {
        return Left(response);
      }

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
