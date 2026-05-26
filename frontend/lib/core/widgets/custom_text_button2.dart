import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';

class CustomTextButton2 extends StatelessWidget {
  final String label;
  final String route;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? semanticLabel;
  final String? tooltip;

  const CustomTextButton2({
    super.key,
    this.label = 'Enter Location Manually',
    required this.route,
    this.textColor = AppColors.primary,
    this.fontSize,
    this.fontWeight = FontWeight.w600,
    this.semanticLabel,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final a11yLabel = semanticLabel ?? label;

    return Semantics(
      button: true,
      label: a11yLabel,
      child: Tooltip(
        message: tooltip ?? a11yLabel,
        child: TextButton(
          onPressed: () {
            context.go(route);
          },
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize ?? AppSizes.sp16,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
    );
  }
}
