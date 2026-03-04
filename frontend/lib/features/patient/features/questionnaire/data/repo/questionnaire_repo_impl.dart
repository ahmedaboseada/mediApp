import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:medi/core/core.dart';
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
      final token = await PrefHelper.getAccessToken();
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

      final message = response['message'] ?? 'Health step 1 completed successfully';
      return Right(message);
    } on DioException catch (e) {
      final serverFailure = ServerFailure.fromDioError(e);
      return Left(serverFailure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
