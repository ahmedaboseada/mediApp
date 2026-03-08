import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class CaretakerCard extends StatelessWidget {
  final String name;
  final String email;
  final String since;
  final String initials;

  const CaretakerCard({
    super.key,
    required this.name,
    required this.email,
    required this.since,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSizes.h12),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.w16),
        child: Row(
          children: [
            Container(
              width: AppSizes.w48,
              height: AppSizes.h48,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              child: Center(child: Text(initials, style: AppStyles.white16600)),
            ),
            SizedBox(width: AppSizes.w16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppStyles.black14500),
                  SizedBox(height: AppSizes.h4),
                  Text(email, style: AppStyles.secondary12400),
                  SizedBox(height: AppSizes.h4),
                  Text(since, style: AppStyles.tertiary14400),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
