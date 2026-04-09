import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class CriticalModeCard extends StatelessWidget {
  const CriticalModeCard({
    super.key,
    required this.enabled,
    required this.onChanged,
  });

  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 650),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 25 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.w20,
          vertical: AppSizes.h16,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(AppSizes.r16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Critical mode',
                    style: TextStyle(
                      fontSize: AppSizes.sp16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryText,
                    ),
                  ),
                  SizedBox(height: AppSizes.h4),
                  Text(
                    'Enable full-screen reminders',
                    style: TextStyle(
                      fontSize: AppSizes.sp12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            CustomToggleSwitch(
              value: enabled,
              onChanged: onChanged,
              width: 50,
              height: 26,
              activeColor: const Color(0xFF34C759),
            ),
          ],
        ),
      ),
    );
  }
}
