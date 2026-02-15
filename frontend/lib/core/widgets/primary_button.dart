import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi/core/core.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    this.backgroundColor = AppColors.primary,
    this.textColor = Colors.white,
    this.text,
    this.borderRadius = const BorderRadius.all(Radius.circular(80)),
    this.onPressed,
    this.child,
  });
  final Color backgroundColor;
  final Color textColor;
  final String? text;
  final BorderRadius borderRadius;
  final Function()? onPressed;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        disabledBackgroundColor: AppColors.disabledColor,

        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 40.w),
        elevation: 0,
      ),
      child:
          child ??
          Text(
            text ?? '',
            style: TextStyle(
              color: textColor,
              fontSize: AppSizes.sp16,
              fontWeight: FontWeight.w600,
            ),
          ),
    );
  }
}
