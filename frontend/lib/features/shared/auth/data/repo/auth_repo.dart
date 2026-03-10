import 'package:dartz/dartz.dart';
import 'dart:io';
import 'package:medi/core/core.dart';
import 'package:medi/features/shared/auth/data/models/auth_token_model.dart';
import 'package:medi/features/shared/auth/data/models/auth_response_model.dart';
import 'package:medi/features/shared/auth/data/models/verify_otp_reponse.dart';

abstract class AuthRepo {
  Future<Either<ApiError, AuthResponseModel>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String confirmPassword,
    required UserRole type,
  });

  Future<Either<ApiError, String>> signInWithEmailAndPassword({
    required String email,
    required String password,
    required UserRole role,
  });
  Future<Either<ApiError, VerifyOtpResponse>> verifyOtp({
    required String email,
    required String otp,
  });

  Future<Either<ApiError, String>> verify2FAOTP({
    required String challengeToken,
    required String otp,
  });

  Future<Either<ApiError, String>> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  });
  Future<Either<ApiError, String>> forgetPassword({required String email});
  Future<Either<ApiError, String>> resendOtp({required String email});
  Future<Either<ApiError, AuthTokensModel>> signInWithGoogle({
    required UserRole userType,
  });

  Future<void> signOut();

  Future<Either<ApiError, String>> completeBasicProfile({
    required String phone,
    required int yearOfBirth,
    required String gender,
    File? profilePicture,
  });

  Future<Either<ApiError, AuthResponseModel>> getMe();

  Future<Either<ApiError, AuthResponseModel>> updateProfile({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? gender,
    String? profilePicture,
    String? specialization,
    String? clinicName,
    String? medicalLicenseId,
  });
}
