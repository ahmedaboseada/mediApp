import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class CaregivingRequestCard extends StatelessWidget {
  final String name;
  final String email;
  final String requestedOn;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const CaregivingRequestCard({
    super.key,
    required this.name,
    required this.email,
    required this.requestedOn,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSizes.h12),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.w16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: AppStyles.black14500),
            SizedBox(height: AppSizes.h4),
            Text(email, style: AppStyles.secondary12400),
            SizedBox(height: AppSizes.h4),
            Text(requestedOn, style: AppStyles.tertiary14400),
            SizedBox(height: AppSizes.h16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: AppSizes.h12),
                    ),
                    onPressed: onAccept,
                    child: Text(
                      'Accept',
                      style: AppStyles.white14500.copyWith(
                        fontSize: AppSizes.sp14,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppSizes.w12),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: AppSizes.h12),
                    ),
                    onPressed: onReject,
                    child: Text(
                      'Reject',
                      style: AppStyles.primary18700.copyWith(
                        fontSize: AppSizes.sp14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
