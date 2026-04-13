import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class LicenseNoticeCard extends StatelessWidget {
  const LicenseNoticeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.h14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAEE),
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(color: const Color(0xFFF2C14A), width: 1.2),
      ),
      child: Text(
        'Important: Please ensure your medical license is valid and clearly visible. '
        'The verification process may take 1-3 business days.',
        style: AppStyles.black14500.copyWith(
          color: const Color(0xFFB56E2C),
          height: 1.45,
        ),
      ),
    );
  }
}
