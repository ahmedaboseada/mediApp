import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medi/core/core.dart';

class MedicineSearchBar extends StatelessWidget {
  const MedicineSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: AppSizes.h48,
            padding: EdgeInsets.symmetric(horizontal: AppSizes.w14),
            decoration: BoxDecoration(
              color: AppColors.surfaceColor,
              borderRadius: BorderRadius.circular(AppSizes.r28),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: AppColors.secondaryText),
                SizedBox(width: AppSizes.w8),
                Text(
                  AppStrings.searchMedications,
                  style: AppStyles.secondary12400.copyWith(
                    fontSize: AppSizes.sp24 * 0.68,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: AppSizes.w12),
        Container(
          width: AppSizes.w48,
          height: AppSizes.h48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(AppSizes.r24),
          ),
          child: SvgPicture.asset(
            AppAssets.medication,
            width: AppSizes.w24,
            height: AppSizes.h24,
          ),
        ),
      ],
    );
  }
}
