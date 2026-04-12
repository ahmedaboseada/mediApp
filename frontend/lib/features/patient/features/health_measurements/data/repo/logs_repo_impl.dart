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
    int? heartRate,
  }) async {
    try {
      final data = {
        'type': type,
        'systolic': systolic,
        'diastolic': diastolic,
        if (heartRate != null) 'heartRate': heartRate,
      };

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
      final dynamic response = await apiService.get(
        '/health/measurements?type=blood_pressure',
      );

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
  Future<Either<ApiError, String>> addHeartRate({
    required String type,
    required int value,
  }) async {
    try {
      final data = {'type': type, 'value': value};

      final dynamic response = await apiService.post(
        '/health/measurements',
        data,
      );

      log('Add Heart Rate Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final message =
          (response is Map<String, dynamic> ? response['message'] : null) ??
          'Heart rate recorded successfully';
      return Right(message.toString());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> getHeartRates() async {
    try {
      final dynamic response = await apiService.get(
        '/health/measurements?type=heart_rate',
      );

      log('Get Heart Rates Response: ${response.toString()}');

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
  Future<Either<ApiError, String>> addBloodSugar({
    required String type,
    required int value,
    String? notes,
  }) async {
    try {
      final data = {
        'type': type,
        'value': value,
        if (notes != null && notes.trim().isNotEmpty) 'notes': notes,
      };

      final dynamic response = await apiService.post(
        '/health/measurements',
        data,
      );

      log('Add Blood Sugar Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final message =
          (response is Map<String, dynamic> ? response['message'] : null) ??
          'Blood sugar recorded successfully';
      return Right(message.toString());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> getBloodSugars() async {
    try {
      final dynamic response = await apiService.get(
        '/health/measurements?type=blood_sugar',
      );

      log('Get Blood Sugars Response: ${response.toString()}');

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
  Future<Either<ApiError, String>> addWeight({
    required String type,
    required double value,
  }) async {
    try {
      final data = {'type': type, 'value': value};

      final dynamic response = await apiService.post(
        '/health/measurements',
        data,
      );

      log('Add Weight Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final message =
          (response is Map<String, dynamic> ? response['message'] : null) ??
          'Weight recorded successfully';
      return Right(message.toString());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> getWeights() async {
    try {
      final dynamic response = await apiService.get(
        '/health/measurements?type=weight',
      );

      log('Get Weights Response: ${response.toString()}');

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
    required List<String> symptoms,
    required String severity,
    required String notes,
  }) async {
    try {
      final data = {'symptoms': symptoms, 'severity': severity, 'notes': notes};

      final dynamic response = await apiService.post('/health/symptoms', data);

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
