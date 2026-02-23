import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/widgets/custom_text_button2.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/widgets/permission_sheet.dart';

class AllowNotificationScreen extends StatelessWidget {
  const AllowNotificationScreen({super.key});

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
                Image.asset(
                AppAssets.allowNotification,
                height: AppSizes.h300,
                fit: BoxFit.contain,
              ),
              // Profile Completed Title
              Text(
                AppStrings.stayUpdated,
                style: AppStyles.black24700.copyWith(color: AppColors.primary),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.h16),
              // Subtitle
              Text(  AppStrings.turnOnNotifications,
                style: AppStyles.tertiary14500,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.h24),

            
              // Let's Start Button
              PrimaryButton(
                text: AppStrings.allowNotifications,
                onPressed: () {
                 
                     _showPermissionSheet(context);
                 
                  }
              ),
              SizedBox(height: AppSizes.h16),
              CustomTextButton2(
                route: AppRouter.mainLayout,
                label: AppStrings.noThanks,
              )
            ],
          ),
        ),
      ),
    );
  }
}
void _showPermissionSheet(
    BuildContext context,
    ) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
     barrierColor: Colors.black.withOpacity(0.5),
    builder: (_) => const PermissionSheet(),
  );
}
