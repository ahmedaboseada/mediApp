import 'package:dartz/dartz.dart';
import 'package:medi/core/core.dart';

abstract class DoctorCompleteProfileRepo {
  Future<Either<ApiError, String>> completeStep1({
    required String specialization,
    required String clinicName,
    required String medicalLicenseId,
    required String phone,
    required String gender,
    String? profilePicture,
  });

  Future<Either<ApiError, String>> completeLocation({
    required String clinicAddress,
    required double lat,
    required double lng,
    required String label,
  });

  Future<Either<ApiError, String>> completeSchedule({
    required List<String> workingDays,
    required String startHour,
    required String endHour,
    required int consultationDuration,
  });

  Future<Either<ApiError, String>> completeAppointments({
    required List<String> appointmentTypes,
    required int maxDailyPatients,
  });

  Future<Either<ApiError, String>> completeLicense({
    required String filePath,
  });
}
