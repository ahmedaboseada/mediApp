import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/patient/features/questionnaire/data/models/questionnaire_model.dart';
import 'package:medi/features/patient/features/questionnaire/data/repo/questionnaire_repo.dart';
import 'package:medi/features/patient/features/questionnaire/presentation/cubit/cubit/questinnaire_state.dart';

class QuestionnaireCubit extends Cubit<QuestionnaireState> {
  final QuestionnaireRepo questionnaireRepo;

  QuestionnaireCubit(this.questionnaireRepo)
    : super(QuestionnaireState(step: 0, data: QuestionnaireModel()));

  void next() => emit(state.copyWith(step: state.step + 1));
  void back() => emit(state.copyWith(step: state.step - 1));

  Future<void> completeHealthStep1() async {
    emit(state.copyWith(isLoading: true));
    
    final result = await questionnaireRepo.completeHealthStep1(
      chronicConditions: state.data.healthConditions ?? [],
      longTermMedication: state.data.longTermMeds ?? [],
      activeIngredients: state.data.activeIngredients ?? [],
    );

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (message) {
        emit(state.copyWith(isLoading: false, error: null));
        next(); // Move to next step after successful submission
      },
    );
  }

  Future<void> completeHealthStep2() async {
    emit(state.copyWith(isLoading: true));
    
    final result = await questionnaireRepo.completeHealthStep2(
      allergies: state.data.allergies ?? [],
      reactionToMedication: state.data.hasAllergies ?? false,
      allergyAlerts: state.data.wantsAllergyAlerts ?? false,
    );

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (message) {
        emit(state.copyWith(isLoading: false, error: null));
        next(); // Move to next step after successful submission
      },
    );
  }

  void updateHealthConditions(List<String> value) {
    state.data.healthConditions = value;
    emit(state.copyWith());
  }

  void updateMedications(List<String> value) {
    state.data.longTermMeds = value;
    emit(state.copyWith());
  }

  void updateActiveIngredients(List<String> value) {
    state.data.activeIngredients = value;
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

  void updateAllergyAlerts(bool value) {
    state.data.wantsAllergyAlerts = value;
    emit(state.copyWith());
  }
}
