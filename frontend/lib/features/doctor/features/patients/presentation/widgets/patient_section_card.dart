import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class PatientSectionCard extends StatelessWidget {
  const PatientSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.w16),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(AppSizes.r40),
        border: Border.all(color: AppColors.borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: AppSizes.w24),
              SizedBox(width: AppSizes.w10),
              Text(
                title,
                style: AppStyles.black18500.copyWith(fontSize: AppSizes.sp20),
              ),
            ],
          ),
          SizedBox(height: AppSizes.h14),
          child,
        ],
      ),
    );
  }
}
