import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class ReminderSimpleListView extends StatelessWidget {
  const ReminderSimpleListView({
    super.key,
    required this.reminders,
    required this.onRemoveReminder,
  });

  final List<String> reminders;
  final ValueChanged<int> onRemoveReminder;

  @override
  Widget build(BuildContext context) {
    if (reminders.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(
        reminders.length,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: AppSizes.h8),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.w12,
              vertical: AppSizes.h12,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.r10),
              border: Border.all(color: AppColors.borderColor),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: AppColors.primary,
                  size: AppSizes.w20,
                ),
                SizedBox(width: AppSizes.w12),
                Text(reminders[index], style: AppStyles.black14500),
                const Spacer(),
                GestureDetector(
                  onTap: () => onRemoveReminder(index),
                  child: Icon(
                    Icons.close,
                    color: Colors.red,
                    size: AppSizes.w20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
