import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class ReminderTimeInputRow extends StatelessWidget {
  const ReminderTimeInputRow({
    super.key,
    required this.timeController,
    required this.onSelectTime,
    required this.onAddReminder,
    required this.reminders,
    required this.onRemoveReminder,
  });

  final TextEditingController timeController;
  final VoidCallback onSelectTime;
  final VoidCallback onAddReminder;
  final List<String> reminders;
  final ValueChanged<int> onRemoveReminder;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            Expanded(
              child: CustomTextField(
                label: 'Time',
                hintText: '00:00',
                controller: timeController,
                readOnly: true,
                onTap: onSelectTime,
                suffixIcon: Icon(Icons.access_time, color: AppColors.primary),
              ),
            ),
            SizedBox(width: AppSizes.w12),
            Padding(
              padding: EdgeInsets.only(top: AppSizes.h20),
              child: GestureDetector(
                onTap: onAddReminder,
                child: Container(
                  width: AppSizes.w48,
                  height: AppSizes.h48,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppSizes.r10),
                  ),
                  child: Icon(
                    Icons.add,
                    color: AppColors.whiteText,
                    size: AppSizes.sp24,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.h16),
        ...List<Widget>.generate(reminders.length, (int index) {
          return Padding(
            padding: EdgeInsets.only(bottom: AppSizes.h8),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.w12,
                vertical: AppSizes.h12,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.r10),
                border: Border.all(color: AppColors.borderColor),
                color: AppColors.surfaceColor,
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.access_time,
                    color: AppColors.primary,
                    size: AppSizes.sp20,
                  ),
                  SizedBox(width: AppSizes.w12),
                  Text(reminders[index], style: AppStyles.black14500),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => onRemoveReminder(index),
                    child: Icon(
                      Icons.close,
                      color: AppColors.error,
                      size: AppSizes.sp18,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
