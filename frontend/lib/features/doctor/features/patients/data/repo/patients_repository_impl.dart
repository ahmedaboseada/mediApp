import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/patients/data/models/patient_model.dart';
import 'package:medi/features/doctor/features/patients/data/repo/patients_repository.dart';

class PatientsRepositoryImpl implements PatientsRepository {
  // Mock data - replace with API calls when backend is ready
  static const List<PatientModel> _mockPatients = [
    PatientModel(
      id: '1',
      name: 'Mai Ali',
      age: 25,
      gender: 'F',
      bloodType: 'A+',
      status: PatientStatus.critical,
      avatarAsset: AppAssets.avatar1,
    ),
    PatientModel(
      id: '2',
      name: 'Reem Saad',
      age: 29,
      gender: 'F',
      bloodType: 'O-',
      status: PatientStatus.abnormal,
      avatarAsset: AppAssets.avatar2,
    ),
    PatientModel(
      id: '3',
      name: 'Ali Mahfouz',
      age: 27,
      gender: 'M',
      bloodType: 'A+',
      status: PatientStatus.missedMeds,
      avatarAsset: AppAssets.avatar3,
    ),
    PatientModel(
      id: '4',
      name: 'Mona Ali',
      age: 23,
      gender: 'F',
      bloodType: 'B+',
      status: PatientStatus.normal,
      avatarAsset: AppAssets.avatar2,
    ),
    PatientModel(
      id: '5',
      name: 'Ahmed Hassan',
      age: 35,
      gender: 'M',
      bloodType: 'AB+',
      status: PatientStatus.normal,
      avatarAsset: AppAssets.avatar1,
    ),
    PatientModel(
      id: '6',
      name: 'Fatima Mohamed',
      age: 31,
      gender: 'F',
      bloodType: 'A-',
      status: PatientStatus.abnormal,
      avatarAsset: AppAssets.avatar2,
    ),
  ];

  @override
  Future<Either<ApiError, List<PatientModel>>> getPatients({
    String? searchQuery,
  }) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 800));

      List<PatientModel> patients = List.from(_mockPatients);

      // Filter by search query if provided
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        patients = patients
            .where((patient) =>
                patient.name.toLowerCase().contains(query) ||
                patient.id.toLowerCase().contains(query))
            .toList();
      }

      return Right(patients);
    } catch (e) {
      return Left(
        ServerFailure('Failed to fetch patients: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<ApiError, PatientModel>> getPatientById(String id) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 600));

      final patient = _mockPatients.firstWhere(
        (p) => p.id == id,
        orElse: () => throw Exception('Patient not found'),
      );

      return Right(patient);
    }on DioException catch (e) {
      return Left(
        ServerFailure('Failed to fetch patient: ${e.message}'),
      );
    }
     catch (e) {
      return Left(
        ServerFailure('Patient not found'),
      );
    }
  }
}
