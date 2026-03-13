import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class AddMeasurementInfoCard extends StatelessWidget {
  const AddMeasurementInfoCard({
    super.key,
    required this.title,
    required this.lines,
  });

  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.w12),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(AppSizes.r10),
        border: Border.all(color: AppColors.focusedBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: AppStyles.primaryDark12400.copyWith(fontSize: AppSizes.sp14,fontWeight: FontWeight.w600),
          ),
          SizedBox(height: AppSizes.h8),
          ...lines.map(
            (String line) => Text(
              line,
              style: AppStyles.primaryDark12400.copyWith(fontSize: AppSizes.sp12,fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
