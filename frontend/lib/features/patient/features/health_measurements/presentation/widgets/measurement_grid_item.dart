import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/health_measurements/data/models/measurement_model.dart';

class MeasurementGridItem extends StatelessWidget {
  const MeasurementGridItem({
    this.backgroundColor,
    this.textColor,
    super.key,
    required this.measurement,
  });

  final MeasurementModel measurement;
  final Color? backgroundColor;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.w12),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.r20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: AppSizes.h40,
                width: AppSizes.w40,
                padding: EdgeInsets.all(AppSizes.w8),
                decoration: BoxDecoration(
                  color: AppColors.whiteText,
                  borderRadius: BorderRadius.circular(AppSizes.r40),
                ),
                child: Center(child: measurement.icon),
              ),
              SizedBox(width: AppSizes.w8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          AppAssets.heartRate,
                          width: AppSizes.w14,
                          height: AppSizes.h14,
                        ),
                        SizedBox(width: AppSizes.w4),
                        Flexible(
                          child: Text(
                            measurement.status,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: textColor ?? AppColors.whiteText,
                              fontSize: AppSizes.sp12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      measurement.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: textColor ?? AppColors.whiteText,
                        fontSize: AppSizes.sp14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSizes.h4),
              Text(
                measurement.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.white14500.copyWith(
                  color: textColor ?? AppColors.whiteText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
