//create class for font styles used in app
import 'package:flutter/material.dart';
import 'package:medi/core/constants/app_colors.dart';
import 'package:medi/core/constants/app_sizes.dart';

class AppStyles {
  // Screen & Section Titles
  static TextStyle screenTitle = TextStyle(
    fontSize: AppSizes.sp24,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryText,
  );

  // Body Text Styles
  static TextStyle subtitleText = TextStyle(
    fontSize: AppSizes.sp14,
    fontWeight: FontWeight.w500,
    color: AppColors.tertiaryText,
  );
  static TextStyle splashScreenTitle = TextStyle(
    fontSize: AppSizes.sp48,
    fontWeight: FontWeight.w100,
    color: AppColors.whiteText,
  );

  static TextStyle bodyText = TextStyle(
    fontSize: AppSizes.sp14,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryText,
  );

  // Form & Input Labels
  static TextStyle assistiveLabel = TextStyle(
    fontSize: AppSizes.sp10,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
  );

  static TextStyle fieldLabel50014 = TextStyle(
    fontSize: AppSizes.sp14,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryText,
  );

  static TextStyle buttonLabel = TextStyle(
    fontSize: AppSizes.sp14,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
  );
  static TextStyle onboardingTitle = TextStyle(
    fontSize: AppSizes.sp24,
    fontWeight: FontWeight.w700,
    color: AppColors.whiteText,
  );
  static TextStyle onboardingSubtitle = TextStyle(
    fontSize: AppSizes.sp14,
    fontWeight: FontWeight.w500,
    color: AppColors.whiteText,
  );

  // Supporting Text
  static final TextStyle supportingText = TextStyle(
    fontSize: AppSizes.sp12,
    color: AppColors.primaryDark,
    fontWeight: FontWeight.w400,
  );
  static TextStyle dividerText40012 = TextStyle(
    fontSize: AppSizes.sp12,
    fontWeight: FontWeight.w400,
    color: AppColors.tertiaryText,
  );
  static TextStyle splashSubtitleText60016 = TextStyle(
    fontSize: AppSizes.sp16,
    fontWeight: FontWeight.w600,
    color: AppColors.whiteText,
  );
  static TextStyle cardTitle70024 = TextStyle(
    fontSize: AppSizes.sp24,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );
  static TextStyle cardtitle40016 = TextStyle(
    fontSize: AppSizes.sp16,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryText,
  );

  // Payout & Withdrawal Screen Styles
  static TextStyle balanceLabel1800Secondary = TextStyle(
    fontSize: AppSizes.sp18,
    fontWeight: FontWeight.w500,
    color: AppColors.secondaryText,
  );

  static TextStyle balanceAmount20700Primary = TextStyle(
    fontSize: AppSizes.sp20,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static TextStyle balanceSubtitle14400Tertiary = TextStyle(
    fontSize: AppSizes.sp14,
    fontWeight: FontWeight.w400,
    color: AppColors.tertiaryText,
  );

  static TextStyle cardTitle18700Primary = TextStyle(
    fontSize: AppSizes.sp18,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryText,
  );
}
