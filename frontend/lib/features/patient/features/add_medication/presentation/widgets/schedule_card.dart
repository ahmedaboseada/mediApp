import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medicine_info_state.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({
    super.key,
    required this.schedule,
    required this.onAddPressed,
  });

  final List<ScheduleItem> schedule;
  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 750),
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
                  Icons.access_time_rounded,
                  size: 20,
                  color: AppColors.secondaryText,
                ),
                SizedBox(width: AppSizes.w8),
                Text(
                  'Schedule',
                  style: TextStyle(
                    fontSize: AppSizes.sp16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.h16),
            ...schedule.asMap().entries.map((entry) {
              return TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 400 + (entry.key * 100)),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(20 * (1 - value), 0),
                      child: child,
                    ),
                  );
                },
                child: _ScheduleItem(item: entry.value),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  const _ScheduleItem({required this.item});

  final ScheduleItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.h12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.time,
                  style: TextStyle(
                    fontSize: AppSizes.sp16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
                SizedBox(height: AppSizes.h4),
                Text(
                  'Duration: ${item.duration}',
                  style: TextStyle(
                    fontSize: AppSizes.sp12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.w12,
              vertical: AppSizes.h6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF2178F3),
              borderRadius: BorderRadius.circular(AppSizes.r8),
            ),
            child: Text(
              item.frequency,
              style: TextStyle(
                fontSize: AppSizes.sp12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
