import 'package:dartz/dartz.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/patients/data/models/patient_data.dart';
import 'dart:developer';
import 'package:medi/features/doctor/features/patients/data/repo/patients_repository.dart';
import '../local/patients_local_data_source.dart';
import '../local/pending_patient_requests_local_data_source.dart';

class PatientsRepositoryImpl implements PatientsRepository {
  PatientsRepositoryImpl(this._apiService, {PatientsLocalDataSource? localDataSource, PendingPatientRequestsLocalDataSource? pendingRequests})
      : _local = localDataSource ?? PatientsLocalDataSource(),
        _pending = pendingRequests ?? PendingPatientRequestsLocalDataSource();

  final ApiService _apiService;
  final PatientsLocalDataSource _local;
  final PendingPatientRequestsLocalDataSource _pending;
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

      if (response is Map<String, dynamic> && response.containsKey('patients')) {
        final List<dynamic> patientsData = response['patients'];
        List<PatientData> patients = patientsData
            .map((data) => PatientData.fromJson(data as Map<String, dynamic>))
            .toList();

        // Persist normalized raw JSON to local cache for offline reads
        final rawList = patientsData.whereType<Map>().map((m) => Map<String, dynamic>.from(m)).toList();
        await _local.savePatients(rawList);

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
      // On network/other failures, surface the error but keep pending queue handling
      return Left(ServerFailure('Failed to fetch patients: ${e.toString()}'));
    }
  }

  @override
  Future<List<PatientData>> getCachedPatients() async {
    try {
      final raw = await _local.getCachedPatients();
      final patients = raw.map((m) => PatientData.fromJson(m)).toList();
      return patients;
    } catch (e) {
      log('PatientsRepositoryImpl: failed to read cache: $e');
      return [];
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
        // Save to pending queue for later sync
        await _pending.addPendingRequest({'patientId': patientId, 'createdAt': DateTime.now().toIso8601String()});
        return Left(response);
      }

      return const Right(null);
    } catch (e) {
      // Save to pending queue for later sync
      await _pending.addPendingRequest({'patientId': patientId, 'createdAt': DateTime.now().toIso8601String()});
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, void>> cancelPatientRequest(String patientId) async {
    try {
      final response = await _apiService.patch(
        '/doctors/patients/cancel/$patientId',
        {},
      );

      log('cancelPatientRequest response: $response');

      if (response is ServerFailure) {
        return Left(response);
      }

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
