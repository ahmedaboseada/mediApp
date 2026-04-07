import 'package:dartz/dartz.dart';
import 'package:medi/core/core.dart';

abstract class LogsRepo {
  Future<Either<ApiError, String>> addBloodPressure({
    required String type,
    required int systolic,
    required int diastolic,
    int? heartRate,
  });

  Future<Either<ApiError, dynamic>> getBloodPressures();

  Future<Either<ApiError, String>> addHeartRate({
    required String type,
    required int value,
  });

  Future<Either<ApiError, dynamic>> getHeartRates();

  Future<Either<ApiError, String>> addBloodSugar({
    required String type,
    required int value,
    String? notes,
  });

  Future<Either<ApiError, dynamic>> getBloodSugars();

  Future<Either<ApiError, String>> addWeight({
    required String type,
    required double value,
  });

  Future<Either<ApiError, dynamic>> getWeights();

  Future<Either<ApiError, String>> addSymptomLog({
    required List<String> symptoms,
    required String severity,
    required String notes,
  });

  Future<Either<ApiError, dynamic>> getSymptomLogs();
}
