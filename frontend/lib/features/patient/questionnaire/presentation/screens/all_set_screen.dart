import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class AllSetScreen extends StatelessWidget {
  const AllSetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(AppSizes.w16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppAssets.completeProfile, height: AppSizes.h300),
            Text(
              AppStrings.allSet,
              style: AppStyles.black24700.copyWith(color: AppColors.primary),
              textAlign: TextAlign.center,
            ),
            Text(
              AppStrings.letsAddYourFirstMedication,
              style: AppStyles.black40016.copyWith(color: AppColors.primary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSizes.h40),
            PrimaryButton(
              text: AppStrings.addMedication,
              onPressed: () {
                // context.go(AppRouter.addMedicationScreen);
              },
            ),
          ],
        ),
      ),
    );
  }
}
