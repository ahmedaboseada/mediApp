import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';

class MedicineStatusBadge extends StatelessWidget {
  const MedicineStatusBadge({super.key, required this.status});

  final MedicationStockStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bgColor, textColor) = switch (status) {
      MedicationStockStatus.low => (
        AppStrings.low,
        AppColors.medicineStatusLowBackground,
        AppColors.primaryText,
      ),
      MedicationStockStatus.medium => (
        AppStrings.medium,
        AppColors.primary,
        AppColors.whiteText,
      ),
      MedicationStockStatus.good => (
        AppStrings.good,
        AppColors.medicineStatusGoodBackground,
        AppColors.whiteText,
      ),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w12,
        vertical: AppSizes.h4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSizes.r80),
      ),
      child: Text(
        label,
        style: AppStyles.white14500.copyWith(
          color: textColor,
          fontSize: AppSizes.sp12,
        ),
      ),
    );
  }
}
