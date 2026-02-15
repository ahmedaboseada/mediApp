import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class AllowLocationScreen extends StatelessWidget {
  const AllowLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.w16,
            vertical: AppSizes.h32,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Circular container with location icon
              Container(
                width: AppSizes.w120,
                height: AppSizes.h120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF4F8DF7).withOpacity(0.15),
                ),
                child: Center(
                  child: Icon(
                    Icons.location_on_rounded,
                    color: AppColors.primary,
                    size: AppSizes.h50,
                  ),
                ),
              ),
              SizedBox(height: AppSizes.h32),

              // Title text
              Text(
                AppStrings.clinicLocationTitle,
                textAlign: TextAlign.center,
                style: AppStyles.screenTitle,
              ),
              SizedBox(height: AppSizes.h8),

              // Subtitle text
              Text(
                AppStrings.clinicLocationSubtitle,
                textAlign: TextAlign.center,
                style: AppStyles.subtitleText,
              ),
              //const Spacer(),
              SizedBox(height: AppSizes.h40),
              // Allow Location Access button
              PrimaryButton(
                text: AppStrings.allowLocationAccess,
                onPressed: () {
                  // TODO: Implement location permission request
                },
              ),
              SizedBox(height: AppSizes.h24),

              // Enter Location Manually button
              TextButton(
                onPressed: () {
                  // TODO: Navigate to manual location entry
                },
                child: Text(
                  AppStrings.enterLocationManually,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: AppSizes.sp16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
