import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class AddSymptomChip extends StatelessWidget {
  const AddSymptomChip({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.r24),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.w14,
          vertical: AppSizes.h6,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppSizes.r24),
        ),
        child: Text(
          'Add Symptom +',
          style: AppStyles.white14500.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
