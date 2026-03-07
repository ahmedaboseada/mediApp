import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/profile/data/models/caregiver_request_model.dart';
import 'package:medi/features/patient/features/profile/data/repo/profile_repo.dart';

class ProfileRepoImpl implements ProfileRepo {
  final ApiService apiService;

  ProfileRepoImpl(this.apiService);

  @override
  Future<Either<ApiError, String>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final data = {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      };
      final token = HiveService.getAccessToken();
      log('Access Token: $token');
      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      final response = await apiService.patch(
        '/users/changePassword',
        data,
        headers: headers,
      );

      log('Change Password Response: ${response.toString()}');

      // Check if response is an error
      if (response is ServerFailure) {
        return Left(response);
      }

      final message = response['message'] ??
          'Password changed successfully';

      log('Message: $message--------------------------------------------------------------------------');

      return Right(message);
    } on DioException catch (e) {
      final serverFailure = ServerFailure.fromDioError(e);
      return Left(serverFailure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

 @override
Future<Either<ApiError, String>> requestEmailChange({
  required String newEmail,
}) async {
  try {
    final data = {
      'newEmail': newEmail,
    };

    final token = HiveService.getAccessToken();

    final response = await apiService.patch(
      '/users/email/change',
      data,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
 if (response is ServerFailure) {
        return Left(response);
      }
    log('Request Email Change Response: ${response.toString()}');

    final message = response['message'] ??
        'Email change request sent successfully';

    return Right(message);
  } on DioException catch (e) {
    return Left(ServerFailure.fromDioError(e));
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}

  @override
  Future<Either<ApiError, String>> cancelEmailChange() async {
    try {
      final token = HiveService.getAccessToken();
      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      final response = await apiService.patch(
        '/users/email/cancel',
        {},
        headers: headers,
      );

      log('Cancel Email Change Response: ${response.toString()}');

      // Check if response is an error
      if (response is ServerFailure) {
        return Left(response);
      }

      final message = response['message'] ??
          'Email change cancelled successfully';

      return Right(message);
    } on DioException catch (e) {
      final serverFailure = ServerFailure.fromDioError(e);
      return Left(serverFailure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> confirmEmailChange({
    required String confirmEmailChangeToken,
  }) async {
    try {
      final response = await apiService.get(
        '/users/confirmEmailChange/$confirmEmailChangeToken',
      );

      log('Confirm Email Change Response: ${response.toString()}');

      // Check if response is an error
      if (response is ServerFailure) {
        return Left(response);
      }

      final message = response['message'] ??
          'Email changed successfully';

      return Right(message);
    } on DioException catch (e) {
      final serverFailure = ServerFailure.fromDioError(e);
      return Left(serverFailure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> toggleTwoFactorAuth(bool enabled) async {
    try {
      final token = HiveService.getAccessToken();
      log('Access Token: $token');
      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      final response = await apiService.patch(
        '/users/2fa',
        {'enabled': enabled},
        headers: headers,
      );

      log('Toggle Two-Factor Auth Response: ${response.toString()}');

      // Check if response is an error
      if (response is ServerFailure) {
        return Left(response);
      }

      final message = response['message'] ??
          'Two-Factor Authentication toggled successfully';

      return Right(message);
    } on DioException catch (e) {
      final serverFailure = ServerFailure.fromDioError(e);
      return Left(serverFailure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, List<CaregiverRequestModel>>> listCaregiverRequests() async {
    try {
      final token = HiveService.getAccessToken();
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await apiService.get(
        '/patients/caregiver/requests',
        headers: headers,
      );

      if (response is ServerFailure) {
        return Left(response);
      }

      final requestsJson = (response['requests'] as List<dynamic>? ?? []);
      final requests = requestsJson
          .whereType<Map<String, dynamic>>()
          .map(CaregiverRequestModel.fromJson)
          .toList();

      return Right(requests);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> acceptCaregiverRequest({
    required String requestId,
  }) async {
    try {
      final token = HiveService.getAccessToken();
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await apiService.patch(
        '/patients/caregiver/requests/$requestId/accept',
        {},
        headers: headers,
      );

      if (response is ServerFailure) {
        return Left(response);
      }

      final message = response['message'] ?? 'Request accepted';
      return Right(message.toString());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> rejectCaregiverRequest({
    required String requestId,
  }) async {
    try {
      final token = HiveService.getAccessToken();
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await apiService.patch(
        '/patients/caregiver/requests/$requestId/reject',
        {},
        headers: headers,
      );

      if (response is ServerFailure) {
        return Left(response);
      }

      final message = response['message'] ?? 'Request rejected';
      return Right(message.toString());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
