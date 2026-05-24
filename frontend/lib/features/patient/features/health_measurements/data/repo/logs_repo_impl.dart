import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/data/local/health_logs_local_data_source.dart';
import 'package:medi/core/data/sync/sync_service.dart';
import 'package:medi/features/patient/features/health_measurements/data/repo/logs_repo.dart';

class LogsRepoImpl implements LogsRepo {
  final ApiService apiService;
  final HealthLogsLocalDataSource localDataSource;

  LogsRepoImpl(this.apiService, {HealthLogsLocalDataSource? localDataSource})
      : localDataSource = localDataSource ?? HealthLogsLocalDataSource();

  @override
  Future<Either<ApiError, String>> addBloodPressure({
    required String type,
    required int systolic,
    required int diastolic,
    int? heartRate,
    bool persistLocal = true,
  }) async {
    final data = {
      'type': type,
      'systolic': systolic,
      'diastolic': diastolic,
      'heartRate': heartRate,
    };

    try {
      final dynamic response = await apiService.post(
        '/health/measurements',
        data,
      );

      log('Add Blood Pressure Response: ${response.toString()}');

      if (response is ServerFailure) {
        if (_isOfflineFailure(response)) {
          if (persistLocal) {
            await localDataSource.appendMeasurement(
              type: type,
              payload: data,
            );
          }
          await SyncService.addToQueue(
            type: 'add',
            entity: 'measurement',
            data: data,
          );
          return Right('Saved locally. Will sync when online.');
        }
        return Left(response);
      }

      final message =
          (response is Map<String, dynamic> ? response['message'] : null) ??
          'Blood pressure recorded successfully';
      if (persistLocal) {
        await localDataSource.appendMeasurement(type: type, payload: data);
      }
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
        final cached = localDataSource.getMeasurementResponse('blood_pressure');
        if (cached != null) {
          return Right(cached);
        }
        return Left(response);
      }

      await localDataSource.saveMeasurementResponse('blood_pressure', response);

      return Right(response);
    } on DioException catch (e) {
      if (_isOfflineException(e)) {
        final cached = localDataSource.getMeasurementResponse('blood_pressure');
        if (cached != null) {
          return Right(cached);
        }
      }
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> addHeartRate({
    required String type,
    required int value,
    bool persistLocal = true,
  }) async {
    final data = {'type': type, 'value': value};

    try {
      final dynamic response = await apiService.post(
        '/health/measurements',
        data,
      );

      log('Add Heart Rate Response: ${response.toString()}');

      if (response is ServerFailure) {
        if (_isOfflineFailure(response)) {
          if (persistLocal) {
            await localDataSource.appendMeasurement(
              type: type,
              payload: data,
            );
          }
          await SyncService.addToQueue(
            type: 'add',
            entity: 'measurement',
            data: data,
          );
          return Right('Saved locally. Will sync when online.');
        }
        return Left(response);
      }

      final message =
          (response is Map<String, dynamic> ? response['message'] : null) ??
          'Heart rate recorded successfully';
      if (persistLocal) {
        await localDataSource.appendMeasurement(type: type, payload: data);
      }
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
        final cached = localDataSource.getMeasurementResponse('heart_rate');
        if (cached != null) {
          return Right(cached);
        }
        return Left(response);
      }

      await localDataSource.saveMeasurementResponse('heart_rate', response);

      return Right(response);
    } on DioException catch (e) {
      if (_isOfflineException(e)) {
        final cached = localDataSource.getMeasurementResponse('heart_rate');
        if (cached != null) {
          return Right(cached);
        }
      }
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
    bool persistLocal = true,
  }) async {
    final data = {
      'type': type,
      'value': value,
      if (notes != null && notes.trim().isNotEmpty) 'notes': notes,
    };

    try {
      final dynamic response = await apiService.post(
        '/health/measurements',
        data,
      );

      log('Add Blood Sugar Response: ${response.toString()}');

      if (response is ServerFailure) {
        if (_isOfflineFailure(response)) {
          if (persistLocal) {
            await localDataSource.appendMeasurement(
              type: type,
              payload: data,
            );
          }
          await SyncService.addToQueue(
            type: 'add',
            entity: 'measurement',
            data: data,
          );
          return Right('Saved locally. Will sync when online.');
        }
        return Left(response);
      }

      final message =
          (response is Map<String, dynamic> ? response['message'] : null) ??
          'Blood sugar recorded successfully';
      if (persistLocal) {
        await localDataSource.appendMeasurement(type: type, payload: data);
      }
      return Right(message.toString());
    } on DioException catch (e) {
      if (_isOfflineException(e)) {
        if (persistLocal) {
          await localDataSource.appendMeasurement(type: type, payload: data);
        }
        await SyncService.addToQueue(
          type: 'add',
          entity: 'measurement',
          data: data,
        );
        return Right('Saved locally. Will sync when online.');
      }
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
        final cached = localDataSource.getMeasurementResponse('blood_sugar');
        if (cached != null) {
          return Right(cached);
        }
        return Left(response);
      }

      await localDataSource.saveMeasurementResponse('blood_sugar', response);

      return Right(response);
    } on DioException catch (e) {
      if (_isOfflineException(e)) {
        final cached = localDataSource.getMeasurementResponse('blood_sugar');
        if (cached != null) {
          return Right(cached);
        }
      }
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> addWeight({
    required String type,
    required double value,
    bool persistLocal = true,
  }) async {
    final data = {'type': type, 'value': value};

    try {
      final dynamic response = await apiService.post(
        '/health/measurements',
        data,
      );

      log('Add Weight Response: ${response.toString()}');

      if (response is ServerFailure) {
        if (_isOfflineFailure(response)) {
          if (persistLocal) {
            await localDataSource.appendMeasurement(
              type: type,
              payload: data,
            );
          }
          await SyncService.addToQueue(
            type: 'add',
            entity: 'measurement',
            data: data,
          );
          return Right('Saved locally. Will sync when online.');
        }
        return Left(response);
      }

      final message =
          (response is Map<String, dynamic> ? response['message'] : null) ??
          'Weight recorded successfully';
      if (persistLocal) {
        await localDataSource.appendMeasurement(type: type, payload: data);
      }
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
        final cached = localDataSource.getMeasurementResponse('weight');
        if (cached != null) {
          return Right(cached);
        }
        return Left(response);
      }

      await localDataSource.saveMeasurementResponse('weight', response);

      return Right(response);
    } on DioException catch (e) {
      if (_isOfflineException(e)) {
        final cached = localDataSource.getMeasurementResponse('weight');
        if (cached != null) {
          return Right(cached);
        }
      }
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
    bool persistLocal = true,
  }) async {
    final data = {'symptoms': symptoms, 'severity': severity, 'notes': notes};

    try {
      final dynamic response = await apiService.post('/health/symptoms', data);

      log('Add Symptom Log Response: ${response.toString()}');

      if (response is ServerFailure) {
        if (_isOfflineFailure(response)) {
          if (persistLocal) {
            await localDataSource.appendSymptom(payload: data);
          }
          await SyncService.addToQueue(
            type: 'add',
            entity: 'symptom',
            data: data,
          );
          return Right('Saved locally. Will sync when online.');
        }
        return Left(response);
      }

      final message =
          (response is Map<String, dynamic> ? response['message'] : null) ??
          'Symptom log added successfully';
      if (persistLocal) {
        await localDataSource.appendSymptom(payload: data);
      }
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
        final cached = localDataSource.getSymptomResponse();
        if (cached != null) {
          return Right(cached);
        }
        return Left(response);
      }

      await localDataSource.saveSymptomResponse(response);

      return Right(response);
    } on DioException catch (e) {
      if (_isOfflineException(e)) {
        final cached = localDataSource.getSymptomResponse();
        if (cached != null) {
          return Right(cached);
        }
      }
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  bool _isOfflineFailure(ApiError error) {
    final message = error.message.toLowerCase();
    return message.contains('no internet') ||
        message.contains('internet connection') ||
        message.contains('connection timeout') ||
        message.contains('connection to server failed') ||
        message.contains('socketexception') ||
        message.contains('unexpected error occurred');
  }

  bool _isOfflineException(DioException error) {
    final message = error.message?.toLowerCase() ?? '';
    final errorText = error.error?.toString().toLowerCase() ?? '';
    return message.contains('no internet') ||
        message.contains('internet connection') ||
        message.contains('connection timeout') ||
        message.contains('connection to server failed') ||
        message.contains('socketexception') ||
        errorText.contains('socketexception') ||
        errorText.contains('failed host lookup') ||
        errorText.contains('network is unreachable') ||
        errorText.contains('connection refused');
  }
}
