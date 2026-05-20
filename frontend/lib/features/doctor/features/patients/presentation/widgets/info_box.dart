import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class InfoBox extends StatelessWidget {
  const InfoBox({super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.w16),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(AppSizes.r40),
        border: Border.all(color: AppColors.focusedBorderColor, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.shield_outlined,
            color: AppColors.primary,
            size: AppSizes.w24,
          ),
          SizedBox(width: AppSizes.w12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.primary18700.copyWith(
                    fontSize: AppSizes.sp16,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: AppSizes.h8),
                Text(description, style: AppStyles.tertiary40012),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
