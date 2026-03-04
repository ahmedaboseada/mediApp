import 'package:dartz/dartz.dart';
import 'package:medi/core/core.dart';

abstract class QuestionnaireRepo {
  Future<Either<ApiError, String>> completeHealthStep1({
    required List<String> chronicConditions,
    required List<String> longTermMedication,
    required List<String> activeIngredients,
  });

  Future<Either<ApiError, String>> completeHealthStep2({
    required List<String> allergies,
    required bool reactionToMedication,
    required bool allergyAlerts,
  });
}
