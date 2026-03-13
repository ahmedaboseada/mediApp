import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/health_measurements/presentation/controller/health_measurements/health_measurements_state.dart';

class MeasurementTabs extends StatelessWidget {
  const MeasurementTabs({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  final HealthDashboardTab selectedTab;
  final ValueChanged<HealthDashboardTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.w4),
      decoration: BoxDecoration(
        color: AppColors.whiteText,
        borderRadius: BorderRadius.circular(AppSizes.r80),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _MeasurementTabItem(
              title: AppStrings.measurements,
              isActive: selectedTab == HealthDashboardTab.measurements,
              onTap: () => onTabSelected(HealthDashboardTab.measurements),
            ),
          ),
          SizedBox(width: AppSizes.w8),
          Expanded(
            child: _MeasurementTabItem(
              title: AppStrings.symptoms,
              isActive: selectedTab == HealthDashboardTab.symptoms,
              onTap: () => onTabSelected(HealthDashboardTab.symptoms),
            ),
          ),
        ],
      ),
    );
  }
}

class _MeasurementTabItem extends StatelessWidget {
  const _MeasurementTabItem({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  final String title;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparentColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.r80),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: EdgeInsets.symmetric(
            vertical: AppSizes.h12,
            horizontal: AppSizes.w12,
          ),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.transparentColor,
            borderRadius: BorderRadius.circular(AppSizes.r80),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isActive ? AppColors.whiteText : AppColors.secondaryText,
                fontSize: AppSizes.sp14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
