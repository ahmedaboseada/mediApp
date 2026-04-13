import 'package:flutter/material.dart';
import 'package:medi/core/constants/app_colors.dart';
import 'package:medi/core/constants/app_sizes.dart';

class WorkingDaysWidget extends StatefulWidget {
  const WorkingDaysWidget({super.key, required this.onDaysSelected});

  final Function(List<String>) onDaysSelected;

  @override
  State<WorkingDaysWidget> createState() => _WorkingDaysWidgetState();
}

class _WorkingDaysWidgetState extends State<WorkingDaysWidget> {
  final List<String> days = const [
    "Sat",
    "Sun",
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
  ];

  late List<String> selectedDays = [];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.w36,
      runSpacing: 12,
      children: days.map((day) {
        final isSelected = selectedDays.contains(day);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedDays.remove(day);
              } else {
                selectedDays.add(day);
              }
            });
            widget.onDaysSelected(selectedDays);
          },
          child: Container(
            width: 50,
            height: 40,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xff2F6EDB)
                  : const Color(0xffEEF4FF),
              borderRadius: BorderRadius.circular(AppSizes.r8),
              border: Border.all(color: const Color(0xff2F6EDB)),
            ),
            child: Center(
              child: Text(
                day,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.primaryText,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
