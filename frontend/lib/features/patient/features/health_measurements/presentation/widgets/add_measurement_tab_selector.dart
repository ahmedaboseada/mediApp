import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class AddMeasurementTabSelector extends StatelessWidget {
  const AddMeasurementTabSelector({
    super.key,
    required this.selectedTabIndex,
    required this.onTabSelected,
  });

  final int selectedTabIndex;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.w4),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(AppSizes.r40),
      ),
      child: Row(
        children: <Widget>[
          _TabChip(
            label: AppStrings.bloodPressure,
            isSelected: selectedTabIndex == 0,
            onTap: () => onTabSelected(0),
          ),
          _TabChip(
            label: AppStrings.bloodSugar,
            isSelected: selectedTabIndex == 1,
            onTap: () => onTabSelected(1),
          ),
          _TabChip(
            label: AppStrings.weight,
            isSelected: selectedTabIndex == 2,
            onTap: () => onTabSelected(2),
          ),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  const _TabChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.w8,
            vertical: AppSizes.h8,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.transparentColor,
            borderRadius: BorderRadius.circular(AppSizes.r40),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? AppColors.whiteText : AppColors.secondaryText,
              fontSize: AppSizes.sp14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
