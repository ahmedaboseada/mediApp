import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class CurrentStockField extends StatelessWidget {
  const CurrentStockField({
    super.key,
    required this.controller,
    required this.onIncrement,
    required this.onDecrement,
  });

  final TextEditingController controller;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: AppStyles.black14500.copyWith(color: AppColors.primaryText),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surfaceColor,
        hintText: 'e.g, 30',
        hintStyle: AppStyles.black14500.copyWith(
          color: AppColors.secondaryText,
        ),
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
        suffixIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: onIncrement,
              child: Icon(
                Icons.arrow_drop_up,
                color: AppColors.primary,
                size: AppSizes.w20,
              ),
            ),
            GestureDetector(
              onTap: onDecrement,
              child: Icon(
                Icons.arrow_drop_down,
                color: AppColors.primary,
                size: AppSizes.w20,
              ),
            ),
          ],
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSizes.w12,
          vertical: AppSizes.h12,
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter current stock';
        }
        if (int.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }
}
