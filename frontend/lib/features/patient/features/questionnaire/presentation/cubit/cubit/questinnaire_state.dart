import 'package:medi/features/patient/features/questionnaire/data/models/questionnaire_model.dart';

class QuestionnaireState {
  final int step;
  final QuestionnaireModel data;
  final bool isLoading;
  final String? error;
  final String? caregiverRequestId;

  QuestionnaireState({
    required this.step,
    required this.data,
    this.isLoading = false,
    this.error,
    this.caregiverRequestId,
  });

  QuestionnaireState copyWith({
    int? step,
    QuestionnaireModel? data,
    bool? isLoading,
    String? error,
    String? caregiverRequestId,
  }) {
    return QuestionnaireState(
      step: step ?? this.step,
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      caregiverRequestId: caregiverRequestId ?? this.caregiverRequestId,
    );
  }
}
