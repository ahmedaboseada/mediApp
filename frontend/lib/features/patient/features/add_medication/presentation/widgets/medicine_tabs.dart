import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medicine_state.dart';

class MedicineTabs extends StatelessWidget {
  const MedicineTabs({
    super.key,
    required this.selectedTab,
    required this.allCount,
    required this.activeCount,
    required this.chronicCount,
    required this.onTabSelected,
  });

  final MedicineTab selectedTab;
  final int allCount;
  final int activeCount;
  final int chronicCount;
  final ValueChanged<MedicineTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.w4),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(AppSizes.r80),
      ),
      child: Row(
        children: [
          Expanded(
            child: _MedicineTabItem(
              label: AppStrings.all,
              count: allCount,
              isSelected: selectedTab == MedicineTab.all,
              onTap: () => onTabSelected(MedicineTab.all),
            ),
          ),
          Expanded(
            child: _MedicineTabItem(
              label: AppStrings.active,
              count: activeCount,
              isSelected: selectedTab == MedicineTab.active,
              onTap: () => onTabSelected(MedicineTab.active),
            ),
          ),
          Expanded(
            child: _MedicineTabItem(
              label: AppStrings.chronic,
              count: chronicCount,
              isSelected: selectedTab == MedicineTab.chronic,
              onTap: () => onTabSelected(MedicineTab.chronic),
            ),
          ),
        ],
      ),
    );
  }
}

class _MedicineTabItem extends StatelessWidget {
  const _MedicineTabItem({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(
          vertical: AppSizes.h8,
          horizontal: AppSizes.w8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.transparentColor,
          borderRadius: BorderRadius.circular(AppSizes.r80),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: AppStyles.black14500.copyWith(
                color: isSelected
                    ? AppColors.whiteText
                    : AppColors.secondaryText,
              ),
            ),
            SizedBox(width: AppSizes.w8),
            Container(
              width: AppSizes.w24,
              height: AppSizes.h24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.medicineTabSelectedCountBackground
                    : AppColors.medicineTabUnselectedCountBackground,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$count',
                style: AppStyles.black14500.copyWith(
                  color: isSelected
                      ? AppColors.whiteText
                      : AppColors.secondaryText,
                  fontSize: AppSizes.sp12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
