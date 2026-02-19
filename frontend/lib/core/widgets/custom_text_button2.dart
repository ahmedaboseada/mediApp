import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';

class CustomTextButton2 extends StatelessWidget {
  final String label;
  final String route;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  const CustomTextButton2({
    super.key,
    this.label = 'Enter Location Manually',
    required this.route,
    this.textColor=AppColors.primary,
    this.fontSize,
    this.fontWeight=FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.go(route);
      },
      child: Text(
        label,
        style: TextStyle(
          color: textColor ,
          fontSize: fontSize ?? AppSizes.sp16,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
