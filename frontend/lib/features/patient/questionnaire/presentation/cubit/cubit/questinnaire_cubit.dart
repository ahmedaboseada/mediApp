import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/patient/questionnaire/data/models/questionnaire_model.dart';
import 'package:medi/features/patient/questionnaire/presentation/cubit/cubit/questinnaire_state.dart';

class QuestionnaireCubit extends Cubit<QuestionnaireState> {
  QuestionnaireCubit()
    : super(QuestionnaireState(step: 0, data: QuestionnaireModel()));

  void next() => emit(state.copyWith(step: state.step + 1));
  void back() => emit(state.copyWith(step: state.step - 1));

  void updateHealthConditions(List<String> value) {
    state.data.healthConditions = value;
    emit(state.copyWith());
  }

  void updateMedications(List<String> value) {
    state.data.longTermMeds = value;
    emit(state.copyWith());
  }

  void updateAllergies(bool value) {
    state.data.hasAllergies = value;
    emit(state.copyWith());
  }

  void toggleCaregiver(bool value) {
    state.data.caregiverMode = value;
    emit(state.copyWith());
  }

  void ongoingHealth(bool value) {
    state.data.ongoingHealthConditions = value;
    emit(state.copyWith());
  }

  void updateAllergyList(List<String> value) {
    state.data.allergies = value;
    emit(state.copyWith());
  }
}
