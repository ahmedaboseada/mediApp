import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/questionnaire/constants/constants.dart';
import 'package:medi/features/patient/questionnaire/presentation/cubit/cubit/questinnaire_cubit.dart';
import 'package:medi/features/patient/questionnaire/presentation/widgets/onboarding_progress.dart';
import 'package:medi/features/patient/questionnaire/presentation/widgets/q_text_field_bool.dart';
import 'package:medi/core/widgets/q_text_fileld.dart';

class Q1HealthScreen extends StatelessWidget {
  const Q1HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuestionnaireCubit>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.h16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppStrings.letsLearnMoreAboutYourHealth,
                  style: AppStyles.primary70024.copyWith(
                    fontSize: AppSizes.sp22,
                  ),
                ),
                Image.asset(AppAssets.addInfo, height: AppSizes.h270),

                QTextField(
                  onSelectionChange: (List<String> selectedList) {
                    cubit.updateHealthConditions(selectedList);
                    print(selectedList);
                  },
                  items: QuestionnaireConstants().healthConditions,

                  label: AppStrings.anyHealthConditionsYouLikeToShare,
                ),

                SizedBox(height: AppSizes.h16),

                QTextField(
                  onSelectionChange: (List<String> selectedList) {
                    cubit.updateMedications(selectedList);
                    print(selectedList);
                  },
                  items: QuestionnaireConstants().longTermMedications,
                  label: AppStrings.areYouCurrentlyTakingAnyLongTermMedications,
                ),
                SizedBox(height: AppSizes.h16),
                QTextFieldBoolean(
                  singleSelect: true,
                  onSelectionChange: (value) {
                    cubit.ongoingHealth(value);
                    print(value);
                  },

                  label: AppStrings.doYouManageAnyOngoingHealthConditions,
                ),
                SizedBox(height: AppSizes.h24),
                const OnboardingProgress(step: 0),
                SizedBox(height: AppSizes.h12),
                PrimaryButton(text: 'Next', onPressed: cubit.next),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
