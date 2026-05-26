import 'package:flutter/material.dart';
import 'package:horizontal_calender_mz/horizontal_calender_mz.dart';
import 'package:medi/core/core.dart';

class DoctorProfileCalendar extends StatelessWidget {
  const DoctorProfileCalendar({super.key, required this.selectedDate});

  final ValueNotifier<DateTime?> selectedDate;

  @override
  Widget build(BuildContext context) {
    return HorizontalCalenderMZ(
      selectedDate: selectedDate,
      header: ValueListenableBuilder<DateTime?>(
        valueListenable: selectedDate,
        builder: (context, selected, _) {
          final DateTime value = selected ?? DateTime.now();
          return Text(
            '${_monthName(value.month)} ${value.year}',
            style: AppStyles.black18500.copyWith(fontWeight: FontWeight.w700),
          );
        },
      ),
      selectedbgcolor: AppColors.primary,
      unselectedbgcolor: AppColors.background,
      seldaynamecolor: AppColors.whiteText,
      seldaynumbercolor: AppColors.primary,
      unseldaynamecolor: AppColors.tertiaryText,
      unseldaynumbercolor: AppColors.primaryText,
      selectedbordercolor: Colors.transparent,
      unselectedbordercolor: Colors.transparent,
      calendericon: Icon(
        Icons.chevron_right_rounded,
        size: AppSizes.sp20,
        color: AppColors.secondaryText,
      ),
    );
  }

  String _monthName(int month) {
    const List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
