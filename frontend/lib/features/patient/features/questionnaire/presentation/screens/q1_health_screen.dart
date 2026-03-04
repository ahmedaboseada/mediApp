import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/questionnaire/constants/constants.dart';
import 'package:medi/features/patient/features/questionnaire/presentation/cubit/cubit/questinnaire_cubit.dart';
import 'package:medi/features/patient/features/questionnaire/presentation/cubit/cubit/questinnaire_state.dart';
import 'package:medi/features/patient/features/questionnaire/presentation/widgets/onboarding_progress.dart';

class Q1HealthScreen extends StatelessWidget {
  const Q1HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuestionnaireCubit>();

    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<QuestionnaireCubit, QuestionnaireState>(
        listener: (context, state) {
          if (state.error != null && state.error!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.h16),
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
                  
                
                  Expanded(child: SizedBox(height: AppSizes.h86)),
                  const OnboardingProgress(step: 0),
                  SizedBox(height: AppSizes.h12),
                  PrimaryButton(
                    text: 'Next',
                    onPressed: state.isLoading ? null : () => cubit.completeHealthStep1(),
                    child: state.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                  SizedBox(height: AppSizes.h16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
