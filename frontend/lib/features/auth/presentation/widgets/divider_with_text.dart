import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class DividerWithText extends StatelessWidget {
  const DividerWithText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 50),
      child: Row(
        children: [
          Expanded(child: Divider(color: AppColors.dividerColor, thickness: 1)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.w12),
            child: Text(text, style: AppStyles.dividerText40012),
          ),
          Expanded(child: Divider(color: AppColors.dividerColor, thickness: 1)),
        ],
      ),
    );
  }
}
