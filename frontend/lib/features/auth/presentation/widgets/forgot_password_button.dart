import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class CustomTextButton extends StatelessWidget {
  final Function()? onPressed;
  final String text;

  const CustomTextButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.primary,
          decoration: TextDecoration.underline,
          decorationThickness: 1.5,
          decorationColor: AppColors.primary,
          fontWeight: FontWeight.w500,
          fontSize: AppSizes.sp14,
        ),
      ),
    );
  }
}
