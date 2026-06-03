import 'package:dartz/dartz.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/profile/data/models/caregiver_request_model.dart';
import 'package:medi/features/patient/features/profile/data/models/doctor_request_model.dart';
import 'package:medi/features/patient/features/profile/data/models/managed_patient_summary.dart';

abstract class ProfileRepo {
  Future<Either<ApiError, String>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  });

  Future<Either<ApiError, String>> requestEmailChange({
    required String newEmail,
  });

  Future<Either<ApiError, String>> cancelEmailChange();

  Future<Either<ApiError, String>> confirmEmailChange({
    required String confirmEmailChangeToken,
  });

  Future<Either<ApiError, String>> toggleTwoFactorAuth(bool enabled);

  Future<Either<ApiError, List<CaregiverRequestModel>>> listCaregiverRequests();

  Future<Either<ApiError, List<ManagedPatientSummary>>> listManagedPatients();

  Future<Either<ApiError, String>> acceptCaregiverRequest({
    required String requestId,
  });

  Future<Either<ApiError, String>> rejectCaregiverRequest({
    required String requestId,
  });

  Future<Either<ApiError, List<DoctorRequestModel>>> listDoctorRequests();

  Future<Either<ApiError, String>> acceptDoctorRequest({
    required String doctorId,
    String? doctorFcmToken,
  });

  Future<Either<ApiError, String>> rejectDoctorRequest({
    required String doctorId,
  });

  Future<Either<ApiError, String>> exportHealthPassportPDF({
    required String apiEndpoint,
  });

  Future<Either<ApiError, String>> generateQRToken();

  Future<Either<ApiError, String>> downloadSharedRecord({
    required String qrToken,
  });

  Future<Either<ApiError, String>> completePatientProfile({
    required String phone,
    required int yearOfBirth,
    required String gender,
    List<String>? chronicConditions,
    List<String>? longTermMedication,
    List<String>? allergies,
    bool? reactionToMedication,
    bool? allergyAlerts,
  });
}
