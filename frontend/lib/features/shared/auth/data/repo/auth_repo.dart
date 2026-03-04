import 'package:dartz/dartz.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/shared/auth/data/models/auth_token_model.dart';
import 'package:medi/features/shared/auth/data/models/register_response.dart';
import 'package:medi/features/shared/auth/data/models/verify_otp_reponse.dart';

abstract class AuthRepo {
  Future<Either<ApiError, RegisterResponse>> signUpWithEmailAndPassword({
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
  Future<Either<ApiError, AuthTokensModel>> signInWithGoogle();

  Future<void> signOut();
  
  Future<Either<ApiError, String>> completeBasicProfile({
    required String phone,
    required int yearOfBirth,
    required String gender,
    String? profilePicture,
  });
}
