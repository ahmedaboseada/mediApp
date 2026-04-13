import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medi/core/core.dart';

class SummaryItem extends StatelessWidget {
  const SummaryItem({
    super.key,
    required this.title,
    required this.value,
    this.status = 'Normal',
    required this.leadingIcon,
    this.leadingIconColor = const Color(0xFFD91646),
    this.valueColor = AppColors.primaryDark,
    this.statusColor = const Color(0xFF31B857),
    this.backgroundColor = AppColors.lightBackground,
  });

  final String title;
  final String value;
  final String status;
  final String leadingIcon;
  final Color leadingIconColor;
  final Color valueColor;
  final Color statusColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.w10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.r20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              SvgPicture.asset(
                leadingIcon,
                colorFilter: ColorFilter.mode(
                  leadingIconColor,
                  BlendMode.srcIn,
                ),
                width: AppSizes.w20,
                height: AppSizes.h20,
              ),
              SizedBox(width: AppSizes.w10),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.black14400,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.h10),
          Text(
            value,
            style: AppStyles.primaryDark12400.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSizes.h10),
          Row(
            children: <Widget>[
              SvgPicture.asset(
                AppAssets.heartRate,
                colorFilter: ColorFilter.mode(statusColor, BlendMode.srcIn),
                width: AppSizes.w12,
                height: AppSizes.h12,
              ),
              SizedBox(width: AppSizes.w12),
              Text(
                status,
                style: AppStyles.black10600.copyWith(color: statusColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
