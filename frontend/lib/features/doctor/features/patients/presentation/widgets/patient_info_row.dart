import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class PatientInfoRow extends StatelessWidget {
  const PatientInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor = AppColors.primaryText,
    this.valueFontSize,
  });

  final String label;
  final String value;
  final Color valueColor;
  final double? valueFontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.h8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppStyles.black16400.copyWith(fontSize: AppSizes.sp18),
            ),
          ),
          Text(
            value,
            style: AppStyles.black18500.copyWith(
              color: valueColor,
              fontSize: valueFontSize ?? AppSizes.sp18,
            ),
          ),
        ],
      ),
    );
  }
}

class PatientIconInfoRow extends StatelessWidget {
  const PatientIconInfoRow({
    super.key,
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: AppSizes.w24),
        SizedBox(width: AppSizes.w12),
        Expanded(
          child: Text(
            text,
            style: AppStyles.black16400.copyWith(fontSize: AppSizes.sp16),
          ),
        ),
      ],
    );
  }
}
