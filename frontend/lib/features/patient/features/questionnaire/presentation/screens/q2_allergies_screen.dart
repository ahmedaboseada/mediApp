import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/questionnaire/constants/constants.dart';
import 'package:medi/features/patient/features/questionnaire/presentation/cubit/cubit/questinnaire_cubit.dart';
import 'package:medi/features/patient/features/questionnaire/presentation/widgets/onboarding_progress.dart';
import 'package:medi/features/patient/features/questionnaire/presentation/widgets/q_text_field_bool.dart';

class Q2AllergiesScreen extends StatelessWidget {
  const Q2AllergiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuestionnaireCubit>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: cubit.back,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.h16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: AppSizes.h40),
                Text(
                  AppStrings.hangTight,
                  style: AppStyles.primary70024.copyWith(
                    fontSize: AppSizes.sp22,
                  ),
                  textAlign: TextAlign.center,
                ),
                Image.asset(AppAssets.addInfo, height: AppSizes.h270),
                QTextField(
                  onSelectionChange: (List<String> selectedList) {
                    cubit.updateAllergyList(selectedList);
                    print(selectedList);
                  },
                  items: QuestionnaireConstants().allergies,

                  label: AppStrings.allergiesOrSensitivities,
                ),

                SizedBox(height: AppSizes.h16),
                QTextFieldBoolean(
                  onSelectionChange: (value) {
                    cubit.updateAllergies(value);
                    print(value);
                  },
                  label: AppStrings.reactionToMedication,
                ),

                SizedBox(height: AppSizes.h16),
                QTextFieldBoolean(
                  singleSelect: true,
                  onSelectionChange: (value) {
                    cubit.updateAllergies(value);
                    print(value);
                  },

                  label: AppStrings.allergyAlerts,
                ),
                SizedBox(height: AppSizes.h24),
                const OnboardingProgress(step: 1),
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
