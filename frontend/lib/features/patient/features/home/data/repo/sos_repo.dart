import 'package:dartz/dartz.dart';
import 'package:medi/core/core.dart';

abstract class SosRepo {
  Future<Either<ApiError, String>> setEmergencyContact({
    required String name,
    required String phone,
    required String contactMethod,
  });

  Future<Either<ApiError, String>> triggerSos({
    required double lat,
    required double lng,
  });
}
