import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/constants/app_colors.dart';
import 'package:medi/core/constants/app_sizes.dart';
import 'package:medi/features/doctor/features/settings/presentation/controller/cubit/schedule_cubit.dart';

class WorkingDaysWidget extends StatelessWidget {
  const WorkingDaysWidget({super.key});

  final List<String> days = const [
    "Sat",
    "Sun",
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        return Wrap(
          spacing: AppSizes.w36,
          runSpacing: 12,
          children: days.map((day) {
            final isSelected = state.schedule.workingDays.contains(day);

            return GestureDetector(
              onTap: () =>
                  context.read<ScheduleCubit>().updateWorkingDays([day]),
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
      },
    );
  }
}
