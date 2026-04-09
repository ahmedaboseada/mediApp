import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class CustomToggleSwitch extends StatelessWidget {
  const CustomToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = 64,
    this.height = 28,
    this.activeColor,
    this.inactiveColor,
    this.duration = const Duration(milliseconds: 250),
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final double width;
  final double height;
  final Color? activeColor;
  final Color? inactiveColor;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: AnimatedContainer(
        duration: duration,
        width: width,
        height: height,
        padding: EdgeInsets.all(AppSizes.w2),
        decoration: BoxDecoration(
          color: value
              ? (activeColor ?? AppColors.accent)
              : (inactiveColor ?? AppColors.greyLight),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Align(
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: width * 0.6,
            height: height * 0.85,
            decoration: BoxDecoration(
              color: AppColors.whiteText,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
      ),
    );
  }
}
