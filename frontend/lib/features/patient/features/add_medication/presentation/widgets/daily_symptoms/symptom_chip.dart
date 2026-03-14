import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class SymptomChip extends StatelessWidget {
  const SymptomChip({super.key, required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w12,
        vertical: AppSizes.h6,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(AppSizes.r24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            label,
            style: AppStyles.black14500.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: AppSizes.w4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close,
              size: AppSizes.sp14,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
