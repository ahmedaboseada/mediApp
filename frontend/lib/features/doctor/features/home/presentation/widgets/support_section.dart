import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medi/core/core.dart';

class SupportSection extends StatelessWidget {
  const SupportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.w24,
          vertical: AppSizes.h16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  AppAssets.support,
                  height: AppSizes.h20,
                  width: AppSizes.w20,
                ),
                SizedBox(width: AppSizes.w8),
                Text(
                  'Support',
                  style: AppStyles.black14500.copyWith(fontSize: AppSizes.sp18),
                ),
              ],
            ),
            SizedBox(height: AppSizes.h12),
            InkWell(
              onTap: () {
                // Handle contact support tap
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppSizes.h12),
                child: Text('Help & FAQ', style: AppStyles.black40016),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
