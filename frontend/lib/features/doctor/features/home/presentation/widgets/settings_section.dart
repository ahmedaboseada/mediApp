import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/home/presentation/widgets/settings_tile.dart';
import 'package:medi/features/shared/auth/data/models/doctor_model.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key, required this.doctor});
  final DoctorModel doctor;
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
                  AppAssets.settings,
                  height: AppSizes.h20,
                  width: AppSizes.w20,
                ),
                SizedBox(width: AppSizes.w8),
                Text(
                  'Settings',
                  style: AppStyles.black14500.copyWith(fontSize: AppSizes.sp18),
                ),
              ],
            ),
            SettingsTile(
              title: 'Schedule & Availability',
              onTap: () {
                context.push(AppRouter.availabilityScreen, extra: doctor);
              },
            ),
            SettingsTile(
              title: 'Payout & Withdrawal',
              onTap: () {
                context.push(AppRouter.payoutWithdrawalScreen);
              },
            ),
            SettingsTile(
              title: 'Account Information',
              onTap: () {
                context.push(AppRouter.accountInformationScreen);
              },
            ),
            SettingsTile(title: 'Security & Privacy', onTap: () {}),
          ],
        ),
      ),
    );
  }
}
