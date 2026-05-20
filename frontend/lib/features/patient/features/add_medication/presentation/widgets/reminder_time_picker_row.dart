import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class ReminderTimePickerRow extends StatelessWidget {
  const ReminderTimePickerRow({
    super.key,
    required this.timeController,
    required this.onSelectTime,
    required this.onAddReminder,
  });

  final TextEditingController timeController;
  final VoidCallback onSelectTime;
  final VoidCallback onAddReminder;

  @override
  Widget build(BuildContext context) {
    return Row(
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
              child: Icon(Icons.add, color: Colors.white, size: AppSizes.w24),
            ),
          ),
        ),
      ],
    );
  }
}
