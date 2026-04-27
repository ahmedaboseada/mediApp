import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medi/core/core.dart';

class MedicationDetailCol extends StatelessWidget {
  const MedicationDetailCol({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final String icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          icon,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
        ),
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
