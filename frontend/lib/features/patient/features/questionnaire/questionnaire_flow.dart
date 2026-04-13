import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/patient/features/questionnaire/presentation/cubit/cubit/questinnaire_cubit.dart';
import 'package:medi/features/patient/features/questionnaire/presentation/cubit/cubit/questinnaire_state.dart';
import 'package:medi/features/patient/features/questionnaire/presentation/screens/q3_caregiver_mode_screen.dart';
import 'package:medi/features/patient/features/questionnaire/presentation/screens/q1_health_screen.dart';
import 'package:medi/features/patient/features/questionnaire/presentation/screens/q2_allergies_screen.dart';

class OnboardingFlow extends StatelessWidget {
  const OnboardingFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestionnaireCubit, QuestionnaireState>(
      builder: (context, state) {
        switch (state.step) {
          case 0:
            return const Q1HealthScreen();
          case 1:
            return const Q2AllergiesScreen();
          case 2:
            return const CaregiverModeScreen();
          default:
            return const SizedBox();
        }
      },
    );
  }
}
