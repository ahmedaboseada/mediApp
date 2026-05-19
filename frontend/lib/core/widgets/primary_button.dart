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
    this.semanticLabel,
    this.tooltip,
  });
  final Color backgroundColor;
  final Color textColor;
  final String? text;
  final BorderRadius borderRadius;
  final Function()? onPressed;
  final Widget? child;
  
  /// Accessibility: Semantic label for screen readers.
  /// If not provided, uses the button text.
  final String? semanticLabel;
  
  /// Accessibility: Tooltip text for hover/long-press.
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final label = semanticLabel ?? text ?? '';
    
    return Semantics(
      button: true,
      enabled: onPressed != null,
      onTap: onPressed,
      label: label,
      child: Tooltip(
        message: tooltip ?? label,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            side: BorderSide(color: AppColors.primary, width: 1.w),
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
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
        ),
      ),
    );
  }
}
