//  implement DoctorsRepository

import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/doctors/data/models/doctor_summary.dart';
import 'package:medi/features/patient/features/doctors/data/repo/doctors_repo.dart';

class DoctorsRepositoryImpl implements DoctorsRepository {
  final ApiService apiService;

  DoctorsRepositoryImpl(this.apiService);

  @override
  Future<Either<ApiError, List<DoctorModel>>> getGlobalDoctors() async {
    try {
      final dynamic response = await apiService.get("/doctors/directory");

      log('Get Doctors Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      // 👇 هنا بنقرأ doctors من الresponse
      final List<dynamic> rawList = response['doctors'] ?? [];

      final doctors = rawList
          .whereType<Map>()
          .map((item) => DoctorModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();

      return Right(doctors);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
