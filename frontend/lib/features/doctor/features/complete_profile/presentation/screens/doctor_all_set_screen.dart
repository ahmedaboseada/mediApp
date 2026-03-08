import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';

class DoctorAllSetScreen extends StatelessWidget {
  const DoctorAllSetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(AppSizes.w16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStrings.youAreAllSet,
              style: AppStyles.black24700.copyWith(color: AppColors.primary),
              textAlign: TextAlign.center,
            ),
            Image.asset(AppAssets.completeProfile, height: AppSizes.h300),

            SizedBox(height: AppSizes.h40),
            PrimaryButton(
              text: AppStrings.okay,
              onPressed: () {
                context.go(AppRouter.mainLayout);
              },
            ),
          ],
        ),
      ),
    );
  }
}
