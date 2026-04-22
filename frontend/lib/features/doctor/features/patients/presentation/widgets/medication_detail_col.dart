import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class MedicationDetailCol extends StatelessWidget {
  const MedicationDetailCol({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        SizedBox(height: AppSizes.h8),
        Text(
          label,
          style: AppStyles.secondary12400.copyWith(fontSize: AppSizes.sp12),
        ),
        SizedBox(height: AppSizes.h4),
        Text(
          value,
          style: AppStyles.black14500.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
