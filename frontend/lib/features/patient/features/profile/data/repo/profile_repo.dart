import 'package:dartz/dartz.dart';
import 'package:medi/core/core.dart';

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
}
