import 'package:medi/features/patient/questionnaire/data/models/questionnaire_model.dart';

class QuestionnaireState {
  final int step;
  final QuestionnaireModel data;

  QuestionnaireState({required this.step, required this.data});

  QuestionnaireState copyWith({int? step, QuestionnaireModel? data}) {
    return QuestionnaireState(step: step ?? this.step, data: data ?? this.data);
  }
}
