import 'package:dartz/dartz.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/home/data/models/emergency_contact_model.dart';

abstract class SosRepo {
  Future<Either<ApiError, String>> setEmergencyContact({
    required String name,
    required String phone,
    required String contactMethod,
  });

  Future<Either<ApiError, String>> triggerSos();
}
