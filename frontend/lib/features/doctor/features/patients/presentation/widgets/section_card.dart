import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medi/core/core.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r24),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.w16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(AppAssets.meds),
                SizedBox(width: AppSizes.w8),
                Text(
                  title,
                  style: AppStyles.black18500.copyWith(fontSize: AppSizes.sp20),
                ),
              ],
            ),
            SizedBox(height: AppSizes.h16),
            child,
          ],
        ),
      ),
    );
  }
}
