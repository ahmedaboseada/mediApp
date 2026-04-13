import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class NavigationButtons extends StatelessWidget {
  final VoidCallback? onBackPressed;
  final VoidCallback? onNextPressed;
  final bool nextEnabled;
  final String backText;
  final String nextText;

  const NavigationButtons({
    super.key,
    required this.onBackPressed,
    required this.onNextPressed,
    required this.nextEnabled,
    this.backText = 'Back',
    this.nextText = 'Next',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: AppSizes.h48,
            child: PrimaryButton(
              onPressed: onBackPressed,
              text: backText,
              backgroundColor: AppColors.whiteText,
              textColor: AppColors.primary,
            ),
          ),
        ),
        SizedBox(width: AppSizes.w12),
        Expanded(
          child: SizedBox(
            height: AppSizes.h48,
            child: PrimaryButton(
              text: nextText,
              onPressed: nextEnabled ? onNextPressed : null,
            ),
          ),
        ),
      ],
    );
  }
}
