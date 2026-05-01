import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class AlertSentScreen extends StatelessWidget {
  final String contactName;
  final String contactMethod;

  const AlertSentScreen({
    super.key,
    required this.contactName,
    required this.contactMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.h24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  // Title
                  Text(
                    'Confirm Emergency Alert',
                    style: AppStyles.black24700,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSizes.h16),

                  // Description
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Your emergency message has been sent to ",
                          style: AppStyles.secondary12400,
                        ),
                        TextSpan(
                          text: contactName,
                          style: AppStyles.black14600,
                        ),
                        TextSpan(
                          text: " via ",
                          style: AppStyles.secondary12400,
                        ),
                        TextSpan(
                          text: contactMethod.toUpperCase(),
                          style: AppStyles.black14600,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSizes.h40),

                  // Success illustration
                  _buildSuccessIllustration(),
                ],
              ),

              // Bottom section with links
              Column(
                children: [
                  // Done button
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: 'Done',
                      onPressed: () {
                        // Navigate back to home
                        Navigator.of(context).popUntil(
                          (route) => route.isFirst,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: AppSizes.h24),

                  // Helper links
                  Text(
                    'Need more help?',
                    style: AppStyles.tertiary14400,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSizes.h12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Call emergency contact
                        },
                        child: Text(
                          'Call emergency contact',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: AppSizes.sp12,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      SizedBox(width: AppSizes.w8),
                      Text(
                        '|',
                        style: AppStyles.tertiary14400,
                      ),
                      SizedBox(width: AppSizes.w8),
                      GestureDetector(
                        onTap: () {
                          // Call doctor
                        },
                        child: Text(
                          'Call your doctor',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: AppSizes.sp12,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIllustration() {
    return SizedBox(
      height: AppSizes.h200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: AppSizes.w80,
              height: AppSizes.h80,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.check_circle,
                  size: AppSizes.w48,
                  color: AppColors.success,
                ),
              ),
            ),
            SizedBox(height: AppSizes.h24),
            Text(
              'Alert Sent',
              style: AppStyles.black18500,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
