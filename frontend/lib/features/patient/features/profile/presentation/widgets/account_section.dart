import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.w20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.person_2_outlined,
                  color: AppColors.primary,
                  size: AppSizes.sp22,
                ),
                SizedBox(width: 8),
                Text(
                  "Account Mode",
                  style: AppStyles.black14500.copyWith(fontSize: AppSizes.sp18),
                ),
              ],
            ),
            SizedBox(height: AppSizes.h20),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: SvgPicture.asset(AppAssets.switchAccount),
              title: Text(
                "Switch to caregiver mode",
                style: AppStyles.black16400,
              ),
              subtitle: Text(
                "Manage profile of someone you care for",
                style: AppStyles.secondary12400,
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: AppColors.primary),
              onTap: () {
                context.push(AppRouter.patientCaregiverModeScreen);
              },
            ),
          ],
        ),
      ),
    );
  }
}
