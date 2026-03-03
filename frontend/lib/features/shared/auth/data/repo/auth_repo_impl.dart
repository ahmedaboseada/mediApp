import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/shared/auth/data/models/auth_token_model.dart';
import 'package:medi/features/shared/auth/data/models/register_response.dart';
import 'package:medi/features/shared/auth/data/models/verify_otp_reponse.dart';

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
  Future<Either<ApiError, String>> signInWithEmailAndPassword({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      final endpoint = role == UserRole.patient
          ? '/users/signin'
          : '/users/signin';
      final dynamic response = await apiService.post(endpoint, {
        'email': email,
        'password': password,
      });
      log(response.toString());

      // Check if response is an error
      if (response is ServerFailure) {
        return Left(response);
      }

      // Extract tokens
      final accessToken = response['accessToken'];
      final refreshToken = response['refreshToken'];
      
      // Save tokens
      await PrefHelper.saveAccessToken(accessToken);
      await PrefHelper.saveRefreshToken(refreshToken);

      // Extract user data
      final user = response['user'];
      await PrefHelper.saveUserProfile(
        firstName: user['firstName'],
        lastName: user['lastName'],
        email: user['email'],
        profileImage: user['profilePicture'],
      );

      // Save user role
      final userRole = user['type'] == 'doctor'
          ? UserRole.doctor
          : UserRole.patient;
      await PrefHelper.saveUserRole(userRole);

      // Save patient data if available
      if (response['patient'] != null) {
        await PrefHelper.savePatientData(response['patient']);
      }

      log(
        'Access Token: $accessToken--------------------------------------------------------------------------',
      );
      return Right(accessToken);
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

      final dynamic response = await apiService.post(
        '/api/auth/google/mobile',
        {'idToken': auth.idToken},
      );

      if (response is ServerFailure) {
        return Left(response);
      }

      final token = AuthTokensModel.fromJson(response);
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

      final dynamic response = await apiService.post('/users/signup', data);

      log(response.toString());

      if (response is ServerFailure) {
        return Left(response);
      }

      final registerResponse = RegisterResponse.fromJson(response);

      // Save tokens
      await PrefHelper.saveAccessToken(registerResponse.accessToken);
      await PrefHelper.saveRefreshToken(registerResponse.refreshToken);

      // Save user data
      await PrefHelper.saveUserProfile(
        firstName: registerResponse.user.firstName,
        lastName: registerResponse.user.lastName,
        email: registerResponse.user.email,
        profileImage: registerResponse.user.profilePicture,
      );

      // Save user role
      final role = registerResponse.user.type == 'doctor'
          ? UserRole.doctor
          : UserRole.patient;
      await PrefHelper.saveUserRole(role);

      // Save patient data
      await PrefHelper.savePatientData(registerResponse.patient.toJson());

      log(
        'Access Token: ${registerResponse.accessToken}--------------------------------------------------------------------------',
      );

      return Right(registerResponse);
    } on DioException catch (e) {
      final serverFailure = ServerFailure.fromDioError(e);
      return Left(serverFailure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, VerifyOtpResponse>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final data = {'email': email, 'otp': otp};
      final dynamic response = await apiService.post(
        '/users/forgetPassword/verify',
        data,
      );

      if (response is ServerFailure) {
        return Left(response);
      }

      final verifyOtpResponse = VerifyOtpResponse.fromJson(response);
      log(response.toString());
      return Right(verifyOtpResponse);
    } on DioException catch (e) {
      final serverFailure = ServerFailure.fromDioError(e);
      return Left(serverFailure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final data = {
        'resetToken': resetToken,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      };
      final dynamic response = await apiService.post(
        '/users/resetPassword',
        data,
      );

      if (response is ServerFailure) {
        return Left(response);
      }

      final message = response['message'] ?? 'Password reset successfully rere';
      log(response.toString());
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
      final dynamic response = await apiService.post(
        '/users/forgetPassword',
        data,
      );

      if (response is ServerFailure) {
        return Left(response);
      }

      final message =
          response['message'] ?? 'Password reset link sent to your email';
      log(response.toString());
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
      final dynamic response = await apiService.post(
        '/users/requestOTP',
        data,
      );

      if (response is ServerFailure) {
        return Left(response);
      }

      final message = response['message'] ?? 'OTP sent successfully';
      log(response.toString());
      return Right(message);
    } on DioException catch (e) {
      final serverFailure = ServerFailure.fromDioError(e);
      return Left(serverFailure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
