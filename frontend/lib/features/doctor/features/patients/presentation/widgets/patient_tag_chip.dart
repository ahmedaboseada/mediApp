import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class PatientTagChip extends StatelessWidget {
  const PatientTagChip({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w10,
        vertical: AppSizes.h6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFECEC),
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(color: const Color(0xFFFF5C5C), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFFF3D3D), size: 14),
          SizedBox(width: AppSizes.w4),
          Flexible(
            child: Text(
              text,
              // overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: AppStyles.black14400.copyWith(
                color: const Color(0xFFFF3D3D),
                fontSize: AppSizes.sp12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
