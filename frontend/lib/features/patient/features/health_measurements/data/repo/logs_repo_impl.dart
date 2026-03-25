import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/health_measurements/data/repo/logs_repo.dart';

class LogsRepoImpl implements LogsRepo {
  final ApiService apiService;

  LogsRepoImpl(this.apiService);

  @override
  Future<Either<ApiError, String>> addBloodPressure({
    required String type,
    required int systolic,
    required int diastolic,
  }) async {
    try {
      final data = {'type': type, 'systolic': systolic, 'diastolic': diastolic};

      final dynamic response = await apiService.post(
        '/health/measurements',
        data,
      );

      log('Add Blood Pressure Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final message =
          (response is Map<String, dynamic> ? response['message'] : null) ??
          'Blood pressure recorded successfully';
      return Right(message.toString());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> getBloodPressures() async {
    try {
      final dynamic response =
          await apiService.get('/health/measurements?type=blood_pressure');

      log('Get Blood Pressures Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> addSymptomLog({
    required String symptom,
    required String severity,
    required String notes,
  }) async {
    try {
      final data = {'symptom': symptom, 'severity': severity, 'notes': notes};

      final dynamic response = await apiService.post(
        '/health/symptoms',
        data,
      );

      log('Add Symptom Log Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final message =
          (response is Map<String, dynamic> ? response['message'] : null) ??
          'Symptom log added successfully';
      return Right(message.toString());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> getSymptomLogs() async {
    try {
      final dynamic response = await apiService.get('/health/symptoms');

      log('Get Symptom Logs Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
