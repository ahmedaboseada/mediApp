import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({
    super.key,
    required this.reminders,
    this.scheduleTimes = const <MedicationScheduleTime>[],
    required this.frequency,
    required this.duration,
    required this.onAddPressed,
    required this.onReminderTakenChanged,
  });

  final List<String> reminders;
  final List<MedicationScheduleTime> scheduleTimes;
  final String frequency;
  final String duration;
  final VoidCallback onAddPressed;
  final void Function(String time, bool value) onReminderTakenChanged;

  @override
  Widget build(BuildContext context) {
    final entries = scheduleTimes.isNotEmpty
        ? scheduleTimes
        : (reminders.isNotEmpty
              ? reminders
                    .map(
                      (time) =>
                          MedicationScheduleTime(time: time, taken: false),
                    )
                    .toList()
              : const <MedicationScheduleTime>[
                  MedicationScheduleTime(time: '--:--', taken: false),
                ]);

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
            ...entries.asMap().entries.map((entry) {
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
                child: _ScheduleItem(
                  time: entry.value.time,
                  frequency: frequency,
                  isTaken: entry.value.taken,
                  onTakenChanged: (value) =>
                      onReminderTakenChanged(entry.value.time, value),
                ),
              );
            }),
            Text(
              'Duration: $duration',
              style: TextStyle(
                fontSize: AppSizes.sp16,
                fontWeight: FontWeight.w500,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  const _ScheduleItem({
    required this.time,
    required this.frequency,
    required this.isTaken,
    required this.onTakenChanged,
  });

  final String time;
  final String frequency;
  final bool isTaken;
  final ValueChanged<bool> onTakenChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.h12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.w20,
          vertical: AppSizes.h12,
        ),
        decoration: BoxDecoration(
          color: AppColors.disabledColor,
          borderRadius: BorderRadius.circular(AppSizes.r80),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                time,
                style: TextStyle(
                  fontSize: AppSizes.sp16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondaryText,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.w12,
                vertical: AppSizes.h6,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSizes.r80),
              ),
              child: Text(
                frequency,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: AppSizes.sp12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.whiteText,
                ),
              ),
            ),
            SizedBox(width: AppSizes.w8),
            CustomToggleSwitch(
              value: isTaken,
              onChanged: onTakenChanged,
              width: 44,
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
