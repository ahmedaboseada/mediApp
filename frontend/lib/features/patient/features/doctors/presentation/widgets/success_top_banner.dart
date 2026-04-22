import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class SuccessTopBanner extends StatelessWidget {
  const SuccessTopBanner({
    super.key,
    required this.message,
    this.title = 'Success!',
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: AppSizes.w200,
        maxWidth: AppSizes.w300,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF22C55E),
          borderRadius: BorderRadius.circular(AppSizes.r40),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.w12,
          vertical: AppSizes.h10,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSizes.w24,
              height: AppSizes.h24,
              decoration: const BoxDecoration(
                color: Color(0xFF16A34A),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: AppColors.whiteText,
                size: AppSizes.sp16,
              ),
            ),
            SizedBox(width: AppSizes.w10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppStyles.white14500.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(message, style: AppStyles.white14500),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
