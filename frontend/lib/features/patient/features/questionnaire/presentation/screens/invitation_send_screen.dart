import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';

class InvitationSendScreen extends StatelessWidget {
  const InvitationSendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(AppSizes.w16),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(AppAssets.completeProfile, height: AppSizes.h370),
              Text(
                AppStrings.invitationSent,
                style: AppStyles.black24700.copyWith(color: AppColors.primary),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.h16),
              Text(
                AppStrings.invitationSentMessage,
                style: AppStyles.tertiary14500,
                textAlign: TextAlign.center,
              ),
              Spacer(),
              PrimaryButton(
                text: AppStrings.done,
                onPressed: () {
                  context.go('/onboardingFlow/allSet');
                },
              ),
              SizedBox(height: AppSizes.h16),
              SecondryButton(
                text: 'Add another person',
                onPressed: () {
                  context.push('/onboardingFlow/caregiverForm');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
