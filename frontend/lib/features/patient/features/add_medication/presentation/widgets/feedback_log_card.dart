import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medicine_info_state.dart';

class FeedbackLogCard extends StatelessWidget {
  const FeedbackLogCard({super.key, required this.logs});

  final List<FeedbackLogItem> logs;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 850),
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
        padding: EdgeInsets.all(AppSizes.w20),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.description_outlined,
                  size: 20,
                  color: AppColors.secondaryText,
                ),
                SizedBox(width: AppSizes.w8),
                Text(
                  'Daily Feedback Log',
                  style: TextStyle(
                    fontSize: AppSizes.sp16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.h16),
            ...logs.asMap().entries.map((entry) {
              return TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 500 + (entry.key * 150)),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.scale(
                      scale: 0.95 + (0.05 * value),
                      child: child,
                    ),
                  );
                },
                child: _FeedbackLogItem(log: entry.value),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _FeedbackLogItem extends StatelessWidget {
  const _FeedbackLogItem({required this.log});

  final FeedbackLogItem log;

  Color _getSeverityColor() {
    switch (log.severity) {
      case FeedbackSeverity.severe:
        return const Color(0xFFFF3B30);
      case FeedbackSeverity.moderate:
        return const Color(0xFFFF9500);
      case FeedbackSeverity.mild:
        return const Color(0xFF34C759);
    }
  }

  String _getSeverityLabel() {
    switch (log.severity) {
      case FeedbackSeverity.severe:
        return 'Severe';
      case FeedbackSeverity.moderate:
        return 'Moderate';
      case FeedbackSeverity.mild:
        return 'Mild';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getSeverityColor();
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.h12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.date,
                  style: TextStyle(
                    fontSize: AppSizes.sp12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryText,
                  ),
                ),
                SizedBox(height: AppSizes.h4),
                Text(
                  log.description,
                  style: TextStyle(
                    fontSize: AppSizes.sp14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryText,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSizes.w12),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.w12,
              vertical: AppSizes.h6,
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppSizes.r8),
            ),
            child: Text(
              _getSeverityLabel(),
              style: TextStyle(
                fontSize: AppSizes.sp12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
