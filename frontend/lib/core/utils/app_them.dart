import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

ThemeData get lightTheme {
  return ThemeData(
    scaffoldBackgroundColor: Color(0xFFF5F7FB),
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(backgroundColor: AppColors.background),
  );
}
