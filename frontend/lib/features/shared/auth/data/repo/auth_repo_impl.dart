import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/shared/auth/data/models/auth_token_model.dart';
import 'package:medi/features/shared/auth/data/models/register_response.dart';

import 'package:medi/features/shared/auth/data/repo/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final ApiService apiService;
  AuthRepoImpl(this.apiService);
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId:
        '155393712719-3hmq2d3blnlsf7hbf1e6g1bmgre8lk6r.apps.googleusercontent.com',
  );

  @override
  Future<Either<ApiError, AuthTokensModel>> signInWithEmailAndPassword({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      final endpoint = role == UserRole.patient
          ? '/api/auth/login'
          : '/api/auth/login/doctor';
      final Response response = await apiService.post(endpoint, {
        'email': email,
        'password': password,
      });

      final token = AuthTokensModel.fromJson(response.data);
      await PrefHelper.saveAccessToken(token.accessToken);
      await PrefHelper.saveRefreshToken(token.refreshToken);
      log(
        'Access Token: ${token.accessToken}--------------------------------------------------------------------------',
      );
      return Right(token);
    } on DioException catch (e) {
      final serverFailure = ServerFailure.fromDioError(e);
      return Left(serverFailure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, AuthTokensModel>> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      final user = await _googleSignIn.signIn();

      if (user == null) {
        return Left(ServerFailure('Login cancelled'));
      }

      final auth = await user.authentication;
      log(
        'Google Sign In ID Token: ${auth.idToken}--------------------------------------------------------------------------',
      );

      if (auth.idToken == null) {
        return Left(ServerFailure('idToken is null'));
      }

      final Response response = await apiService.post(
        '/api/auth/google/mobile',
        {'idToken': auth.idToken},
      );

      final token = AuthTokensModel.fromJson(response.data);
      await PrefHelper.saveAccessToken(token.accessToken);
      await PrefHelper.saveRefreshToken(token.refreshToken);
      log(
        'Google Sign In Token: ${token.accessToken}--------------------------------------------------------------------------',
      );
      return Right(token);
    } on DioException catch (e) {
      final serverFailure = ServerFailure.fromDioError(e);
      return Left(serverFailure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<void> signOut() async {
    try {
      //final token = await PrefHelper.getAccessToken();

      await apiService.post('/api/auth/logout', {});

      await PrefHelper.clearTokens();
      await _googleSignIn.signOut();
      await PrefHelper.markOnboardingAsNotCompleted();
    } catch (e) {
      log('Logout error: $e');
    }
  }

  @override
  // Future<Either<ApiError, RegisterResponse>> signUpWithEmailAndPassword({
  //   required String email,
  //   required String password,
  //   required String firstName,
  //   required String lastName,
  //   required String confirmPassword,
  //   required UserRole type,
  // }) async {
  //   try {
  //     final data = {
  //       'username': "$firstName $lastName",
  //       'email': email,
  //       'password': password,
  //       'confirmPassword': confirmPassword,
  //       // 'firstName': firstName,
  //       // 'lastName': lastName,
  //     };
  //     final endpoint = type == UserRole.patient
  //         ? 'register'
  //         : '/api/auth/register/doctor';
  //     final Response response = await apiService.post(endpoint, data);
  //     log(response.toString());

  //     final registerResponse = RegisterResponse.fromJson(response.data);
  //     return Right(registerResponse);
  //   } on DioException catch (e) {
  //     final serverFailure = ServerFailure.fromDioError(e);
  //     return Left(serverFailure);
  //   } catch (e) {
  //     return Left(ServerFailure(e.toString()));
  //   }
  // }
  Future<Either<ApiError, RegisterResponse>> signUpWithEmailAndPassword({
  required String email,
  required String password,
  required String firstName,
  required String lastName,
  required String confirmPassword,
  required UserRole type,
  
}) async {
  try {
    final data = {
      'type': type == UserRole.patient ? 'patient' : 'doctor',
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
    
    };

    final Response response =
        await apiService.post('/users/signup', data);

    log(response.toString());

    final registerResponse =
        RegisterResponse.fromJson(response.data);

    return Right(registerResponse);
  } on DioException catch (e) {
    final serverFailure = ServerFailure.fromDioError(e);
    return Left(serverFailure);
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}

  @override
  Future<Either<ApiError, String>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final data = {'email': email, 'otp': otp};
      final Response response = await apiService.post(
        '/api/auth/validate-otp',
        data,
      );

      final message = response.data ?? 'OTP verified successfully rere';
      log(response.data.toString());
      return Right(message);
    } on DioException catch (e) {
      final serverFailure = ServerFailure.fromDioError(e);
      return Left(serverFailure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final data = {'email': email, 'otp': otp, 'newPassword': newPassword};
      final Response response = await apiService.post(
        '/api/auth/reset-password',
        data,
      );

      final message = response.data ?? 'Password reset successfully rere';
      log(response.data.toString());
      return Right(message);
    } on DioException catch (e) {
      final serverFailure = ServerFailure.fromDioError(e);
      return Left(serverFailure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> forgetPassword({
    required String email,
  }) async {
    try {
      final data = {'email': email};
      final Response response = await apiService.post(
        '/api/auth/forgot-password',
        data,
      );

      final message = response.data;
      log(response.data.toString());
      return Right(message);
    } on DioException catch (e) {
      final serverFailure = ServerFailure.fromDioError(e);
      return Left(serverFailure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> resendOtp({required String email}) async {
    try {
      final data = {'email': email};
      final Response response = await apiService.post(
        '/api/auth/resend-otp',
        data,
      );

      final message = response.data;
      log(response.data.toString());
      return Right(message);
    } on DioException catch (e) {
      final serverFailure = ServerFailure.fromDioError(e);
      return Left(serverFailure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
