import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class ProfileCompleted extends StatelessWidget {
  const ProfileCompleted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.w16,
            vertical: AppSizes.h32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppSizes.h40),
              // Profile Completed Title
              Text(
                AppStrings.profileCompletedSuccessfully,
                style: AppStyles.screenTitle.copyWith(color: AppColors.primary),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.h16),
              // Subtitle
              Text(
                AppStrings.startMedicalRemindingJourney,
                style: AppStyles.subtitleText,
                textAlign: TextAlign.center,
              ),
              // Complete Profile Image
              Image.asset(
                AppAssets.completeProfile,
                height: AppSizes.h450,
                fit: BoxFit.contain,
              ),
              // Let's Start Button
              PrimaryButton(
                text: AppStrings.letsStart,
                onPressed: () {
                  // Handle navigation to home or next screen
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
