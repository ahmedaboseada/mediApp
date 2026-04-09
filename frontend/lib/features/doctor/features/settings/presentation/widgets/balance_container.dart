import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medi/core/core.dart';

class BalanceContainer extends StatelessWidget {
  const BalanceContainer({super.key, required this.balance});

  final String balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.balanceContainerBackground,
        borderRadius: BorderRadius.circular(AppSizes.r20),
      ),
      padding: EdgeInsets.all(AppSizes.w16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Balance Row
          Row(
            children: [
              SvgPicture.asset(
                AppAssets.dollar,
                height: AppSizes.h20,
                width: AppSizes.w20,
              ),
              SizedBox(width: AppSizes.w8),
              Text(AppStrings.currentBalance, style: AppStyles.secondary18500),
              Spacer(),
              Text(balance, style: AppStyles.primary20700),
            ],
          ),
          SizedBox(height: AppSizes.h8),
          // Available for Withdrawal Text
          Text(
            AppStrings.availableForWithdrawal,
            style: AppStyles.tertiary14400,
          ),
        ],
      ),
    );
  }
}
