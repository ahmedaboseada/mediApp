import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class PatientStatusPill extends StatelessWidget {
  const PatientStatusPill({super.key, required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w12,
        vertical: AppSizes.h4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(text, style: AppStyles.black14400.copyWith(color: color)),
    );
  }
}
