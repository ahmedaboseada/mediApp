import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class DoctorMonthDaysStrip extends StatelessWidget {
  const DoctorMonthDaysStrip({
    super.key,
    required this.monthLabel,
    required this.days,
    this.selectedIndex = 3,
  });

  final String monthLabel;
  final List<String> days;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: AppSizes.sp20,
              color: AppColors.secondaryText,
            ),
            SizedBox(width: AppSizes.w8),
            Text(
              monthLabel,
              style: AppStyles.black18500.copyWith(fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_left_rounded,
              color: AppColors.secondaryText,
              size: AppSizes.sp24,
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.secondaryText,
              size: AppSizes.sp24,
            ),
          ],
        ),
        SizedBox(height: AppSizes.h12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(days.length, (index) {
              final bool isSelected = index == selectedIndex;
              return Padding(
                padding: EdgeInsets.only(
                  right: index == days.length - 1 ? 0 : AppSizes.w8,
                ),
                child: _DayPill(
                  dayLabel: days[index],
                  isSelected: isSelected,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _DayPill extends StatelessWidget {
  const _DayPill({
    required this.dayLabel,
    required this.isSelected,
  });

  final String dayLabel;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final List<String> parts = dayLabel.split(' ');
    final String dayName = parts.first;
    final String dayNumber = parts.length > 1 ? parts.last : '';

    return Container(
      width: AppSizes.w48,
      padding: EdgeInsets.symmetric(vertical: AppSizes.h8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.r24),
      ),
      child: Column(
        children: [
          Text(
            dayName,
            style: AppStyles.tertiary40012.copyWith(
              color: isSelected ? AppColors.whiteText : AppColors.tertiaryText,
            ),
          ),
          SizedBox(height: AppSizes.h6),
          Text(
            dayNumber,
            style: AppStyles.black14500.copyWith(
              color: isSelected ? AppColors.whiteText : AppColors.primaryText,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}