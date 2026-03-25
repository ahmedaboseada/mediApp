import 'package:dartz/dartz.dart';
import 'package:medi/core/core.dart';

abstract class LogsRepo {
  Future<Either<ApiError, String>> addBloodPressure({
    required String type,
    required int systolic,
    required int diastolic,
  });

  Future<Either<ApiError, dynamic>> getBloodPressures();

  Future<Either<ApiError, String>> addSymptomLog({
    required String symptom,
    required String severity,
    required String notes,
  });

  Future<Either<ApiError, dynamic>> getSymptomLogs();
}
