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
    return Dialog(
      backgroundColor: AppColors.surfaceColor,
      child: Padding(
        padding: EdgeInsets.all(AppSizes.h24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            // Title
            _buildSuccessIllustration(),

            // Description
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Your emergency message has been sent to\n ",
                    style: AppStyles.secondary12400,
                  ),
                  TextSpan(
                    text: "$contactName via ${contactMethod.toUpperCase()}",
                    style: AppStyles.primaryDark12400,
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSizes.h12),

            // Success illustration
            PrimaryButton(
              text: 'Done',
              onPressed: () {
                // Navigate back to home
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
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
            SizedBox(height: AppSizes.h12),
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
