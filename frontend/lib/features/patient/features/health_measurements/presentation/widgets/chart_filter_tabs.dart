import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/health_measurements/presentation/state/health_measurements_state.dart';

class ChartFilterTabs extends StatelessWidget {
  const ChartFilterTabs({
    super.key,
    required this.selectedRange,
    required this.onRangeChanged,
  });

  final ChartFilterRange selectedRange;
  final ValueChanged<ChartFilterRange> onRangeChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _ChartFilterItem(
          label: AppStrings.days7,
          isSelected: selectedRange == ChartFilterRange.days7,
          onTap: () => onRangeChanged(ChartFilterRange.days7),
        ),
        SizedBox(width: AppSizes.w4),
        _ChartFilterItem(
          label: AppStrings.days30,
          isSelected: selectedRange == ChartFilterRange.days30,
          onTap: () => onRangeChanged(ChartFilterRange.days30),
        ),
        SizedBox(width: AppSizes.w4),
        _ChartFilterItem(
          label: AppStrings.days90,
          isSelected: selectedRange == ChartFilterRange.days90,
          onTap: () => onRangeChanged(ChartFilterRange.days90),
        ),
      ],
    );
  }
}

class _ChartFilterItem extends StatelessWidget {
  const _ChartFilterItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparentColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.r200),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.w8,
            vertical: AppSizes.h4,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.disabledColor,
            borderRadius: BorderRadius.circular(AppSizes.r200),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.whiteText : AppColors.secondaryText,
              fontSize: AppSizes.sp10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
