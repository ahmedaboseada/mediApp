import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medi/core/core.dart';

class MethodCard extends StatelessWidget {
  final int index;
  final String iconPath;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const MethodCard({
    super.key,
    required this.index,
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSizes.w16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.r20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderColor,
            width: 1,
          ),
          color: isSelected ? AppColors.lightBackground : Colors.white,
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(AppSizes.w12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.lightBlue,
              ),
              child: SvgPicture.asset(
                iconPath,
                colorFilter: ColorFilter.mode(
                  isSelected ? AppColors.primary : AppColors.primaryText,
                  BlendMode.srcIn,
                ),
                width: AppSizes.w24,
                height: AppSizes.w24,
              ),
            ),
            SizedBox(width: AppSizes.w16),

            // Title and Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppStyles.black16400.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppSizes.h4),
                  Text(subtitle, style: AppStyles.secondary12400),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
