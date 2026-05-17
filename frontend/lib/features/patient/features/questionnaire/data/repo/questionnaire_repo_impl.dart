import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/questionnaire/data/models/caregiver_request_submission_result.dart';
import 'package:medi/features/patient/features/questionnaire/data/repo/questionnaire_repo.dart';

class QuestionnaireRepoImpl implements QuestionnaireRepo {
  final ApiService apiService;

  QuestionnaireRepoImpl(this.apiService);

  @override
  Future<Either<ApiError, String>> completeHealthStep1({
    required List<String> chronicConditions,
    required List<String> longTermMedication,
    required List<String> activeIngredients,
  }) async {
    try {
      final token = HiveService.getAccessToken();
      final data = {
        'chronicConditions': chronicConditions,
        'longTermMedication': longTermMedication,
        'activeIngredients': activeIngredients,
      };

      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      final dynamic response = await apiService.patch(
        '/patients/complete/health1',
        data,
        headers: headers,
      );

      log('Complete Health Step 1 Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final message =
          response['message'] ?? 'Health step 1 completed successfully';
      return Right(message);
    } on DioException catch (e) {
      final serverFailure = ServerFailure.fromDioError(e);
      return Left(serverFailure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> completeHealthStep2({
    required List<String> allergies,
    required bool reactionToMedication,
    required bool allergyAlerts,
  }) async {
    try {
      final token = HiveService.getAccessToken();
      final data = {
        'allergies': allergies,
        'reactionToMedication': reactionToMedication,
        'allergyAlerts': allergyAlerts,
      };

      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      final dynamic response = await apiService.patch(
        '/patients/complete/health2',
        data,
        headers: headers,
      );

      log('Complete Health Step 2 Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final message =
          response['message'] ?? 'Health step 2 completed successfully';
      return Right(message);
    } on DioException catch (e) {
      final serverFailure = ServerFailure.fromDioError(e);
      return Left(serverFailure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, CaregiverRequestSubmissionResult>> sendCaregiverRequest({
    required String caregiverEmail,
    required String relationship,
  }) async {
    try {
      final token = HiveService.getAccessToken();
      final data = {
        'caregiverEmail': caregiverEmail,
        'relationship': relationship,
      };

      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      final dynamic response = await apiService.post(
        '/patients/caregiver/request',
        data,
        headers: headers,
      );

      log('Send Caregiver Request Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      return Right(CaregiverRequestSubmissionResult.fromJson(
        Map<String, dynamic>.from(response as Map),
      ));
    } on DioException catch (e) {
      final serverFailure = ServerFailure.fromDioError(e);
      return Left(serverFailure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> cancelCaregiverRequest({
    required String requestId,
  }) async {
    try {
      final token = HiveService.getAccessToken();
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final dynamic response = await apiService.patch(
        '/patients/caregiver/requests/$requestId/cancel',
        {},
        headers: headers,
      );

      log('Cancel Caregiver Request Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final message = response['message'] ?? 'Caregiver request cancelled successfully';
      return Right(message.toString());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
