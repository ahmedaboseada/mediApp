import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/questionnaire/presentation/cubit/cubit/questinnaire_cubit.dart';
import 'package:medi/features/patient/questionnaire/presentation/widgets/avatar.dart';
import 'package:medi/features/patient/questionnaire/presentation/widgets/onboarding_progress.dart';

class CaregiverModeScreen extends StatelessWidget {
  const CaregiverModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuestionnaireCubit>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            //     color: Theme.of(context).colorScheme.onBackground
          ),
          onPressed: cubit.back,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.w16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppStrings.caregiverMode,
                style: AppStyles.primary70024.copyWith(fontSize: AppSizes.sp26),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.h8),
              Text(
                AppStrings.caregiverModeDescription,
                textAlign: TextAlign.center,
                style: AppStyles.tertiary40012,
              ),
              SizedBox(height: AppSizes.h86),
              Center(
                child: SizedBox(
                  height: AppSizes.h120,
                  width: AppSizes.w260,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Avatar(imagePath: AppAssets.avatar1, left: 0),
                      Avatar(imagePath: AppAssets.avatar2, left: 70),
                      Avatar(imagePath: AppAssets.avatar3, left: 140),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSizes.h48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.addSomeoneYouCareFor,
                    style: AppStyles.primary70024.copyWith(
                      fontSize: AppSizes.sp18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: AppSizes.w20),

                  Container(
                    height: AppSizes.h40,
                    width: AppSizes.w40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    child: IconButton(
                      color: AppColors.whiteText,
                      onPressed: () {
                        context.push(
                          '${AppRouter.onboardingFlow}/caregiverForm',
                        );
                      },
                      icon: Icon(Icons.add),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.h8),
              Text(
                AppStrings.addSomeoneYouCareForDescription,
                textAlign: TextAlign.center,
                style: AppStyles.tertiary40012,
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: AppSizes.h18,
                    color: AppColors.tertiaryText,
                  ),
                  SizedBox(width: AppSizes.w12),

                  Text(
                    AppStrings.manageCaregiverLater,
                    textAlign: TextAlign.center,
                    style: AppStyles.tertiary40012,
                  ),
                ],
              ),
              SizedBox(height: AppSizes.h24),
              OnboardingProgress(step: 2),
              SizedBox(height: AppSizes.h12),
              PrimaryButton(
                text: AppStrings.skipForNow,
                onPressed: () {
                  context.go('/onboardingFlow/allSet');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
