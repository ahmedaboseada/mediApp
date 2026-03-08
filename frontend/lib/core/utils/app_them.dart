import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

ThemeData get lightTheme {
  return ThemeData(
    scaffoldBackgroundColor: Color(0xFFF5F7FB),
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(backgroundColor: AppColors.background),
    cardTheme: CardThemeData(
      color: AppColors.whiteText,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r40),
        side: BorderSide(color: AppColors.cardBorderColor, width: 1),
      ),
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      // filled: true,
      // fillColor: AppColors.surfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.r10),
        borderSide: BorderSide(color: AppColors.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.r10),
        borderSide: BorderSide(color: AppColors.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.r10),
        borderSide: BorderSide(color: AppColors.focusedBorderColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.r10),
        borderSide: BorderSide(color: AppColors.errorBorderColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.r10),
        borderSide: BorderSide(color: AppColors.errorBorderColor),
      ),
    ),
  );
}
