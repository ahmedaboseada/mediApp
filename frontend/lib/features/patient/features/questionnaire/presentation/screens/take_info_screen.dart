import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';

class TakeInfoScreen extends StatelessWidget {
  const TakeInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: null),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(AppAssets.addInfo, height: AppSizes.h300),
          Text(
            AppStrings.letsTakeSomeInfoAboutYourHealth,
            style: AppStyles.black24700.copyWith(color: AppColors.primary),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSizes.h16),
          // Subtitle
          Text(
            AppStrings
                .thisHelpsUsGiveYouSaferMedicationRemindersAndAvoidPossibleRisks,
            style: AppStyles.tertiary14500,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSizes.h32),
          PrimaryButton(
            text: AppStrings.imReady,
            onPressed: () {
              context.go(AppRouter.onboardingFlow);
            },
          ),
        ],
      ),
    );
  }
}
