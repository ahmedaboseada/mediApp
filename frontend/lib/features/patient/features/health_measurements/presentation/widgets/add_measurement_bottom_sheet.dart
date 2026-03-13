import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/health_measurements/presentation/models/measurement_model.dart';

void showAddMeasurementBottomSheet(
  BuildContext context, {
  void Function(MeasurementMetric)? onMetricSelected,
}) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surfaceColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSizes.r32),
      ),
    ),
    builder: (BuildContext context) {
      return SafeArea(child: _AddMeasurementSheet(onMetricSelected: onMetricSelected));
    },
  );
}

class _AddMeasurementSheet extends StatelessWidget {
  const _AddMeasurementSheet({this.onMetricSelected});

  final void Function(MeasurementMetric)? onMetricSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSizes.w24,
        AppSizes.h16,
        AppSizes.w24,
        AppSizes.h32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Title
          Text(
            AppStrings.addMeasurements,
            style: TextStyle(
              color: AppColors.primaryText,
              fontSize: AppSizes.sp18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppSizes.h24),
          // Items grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _MeasurementOption(
                label: AppStrings.heartRate,
                iconPath: AppAssets.heartRateIcon,
                iconBgColor: AppColors.heartRateIconBackground,
                iconColor: AppColors.heartRateIconColor,
                onTap: () => _onTap(context, MeasurementMetric.heartRate),
              ),
              _MeasurementOption(
                label: AppStrings.bloodPressure,
                iconPath: AppAssets.bloodPressureIcon,
                iconBgColor: AppColors.bloodPressureIconBackground,
                iconColor: AppColors.bloodPressureIconColor,
                onTap: () => _onTap(context, MeasurementMetric.bloodPressure),
              ),
              _MeasurementOption(
                label: AppStrings.bloodSugar,
                iconPath: AppAssets.bloodSugarIcon,
                iconBgColor: AppColors.bloodSugarIconBackground,
                iconColor: AppColors.bloodSugarIconColor,
                onTap: () => _onTap(context, MeasurementMetric.bloodSugar),
              ),
            ],
          ),
          SizedBox(height: AppSizes.h24),
          _MeasurementOption(
            label: AppStrings.weight,
            iconPath: AppAssets.weightScaleIcon,
            iconBgColor: AppColors.weightIconBackground,
            iconColor: AppColors.weightIconColor,
            onTap: () => _onTap(context, MeasurementMetric.bodyWeight),
          ),
          SizedBox(height: AppSizes.h24),
          // Close button
          InkWell(
            onTap: () => Navigator.maybePop(context),
            borderRadius: BorderRadius.circular(AppSizes.r12),
            child: Container(
              width: AppSizes.w48,
              height: AppSizes.h48,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSizes.r12),
              ),
              child: Icon(
                Icons.close_rounded,
                color: AppColors.surfaceColor,
                size: AppSizes.sp22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onTap(BuildContext context, MeasurementMetric metric) {
    Navigator.maybePop(context);
    onMetricSelected?.call(metric);
  }
}

class _MeasurementOption extends StatelessWidget {
  const _MeasurementOption({
    required this.label,
    required this.iconPath,
    required this.iconBgColor,
    required this.iconColor,
    required this.onTap,
  });

  final String label;
  final String iconPath;
  final Color iconColor;
  final Color iconBgColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.r16),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.w8,
          vertical: AppSizes.h4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: AppSizes.w56,
              height: AppSizes.h56,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(AppSizes.r16),
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconPath,
                  colorFilter: ColorFilter.mode(
                    iconColor,
                    BlendMode.srcIn,
                  ),
                  width: AppSizes.w32,
                  height: AppSizes.h32,
                ),
              ),
            ),
            SizedBox(height: AppSizes.h8),
            Text(
              label,
              style: TextStyle(
                color: AppColors.primaryText,
                fontSize: AppSizes.sp12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
