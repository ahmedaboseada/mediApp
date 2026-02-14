import 'package:dartz/dartz.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/auth/data/models/auth_token_model.dart';
import 'package:medi/features/auth/data/models/register_response.dart';

abstract class AuthRepo {
  Future<Either<ApiError, RegisterResponse>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String confirmPassword,
    required String firstName,
    required String lastName,
    required UserRole role,
  });

  Future<Either<ApiError, AuthTokensModel>> signInWithEmailAndPassword({
    required String email,
    required String password,
    required UserRole role,
  });
  Future<Either<ApiError, String>> verifyOtp({
    required String email,
    required String otp,
  });
  Future<Either<ApiError, String>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });
  Future<Either<ApiError, String>> forgetPassword({required String email});
  Future<Either<ApiError, String>> resendOtp({required String email});
  Future<Either<ApiError, AuthTokensModel>> signInWithGoogle();

  Future<void> signOut();
}
