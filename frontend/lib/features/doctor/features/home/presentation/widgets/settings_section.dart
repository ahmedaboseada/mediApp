import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/home/presentation/widgets/settings_tile.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r40),
        side: BorderSide(color: AppColors.cardBorderColor, width: 1),
      ),
      color: AppColors.whiteText,
      elevation: 0,
      child: Column(
        children: [
          Text('Settings', style: AppStyles.screenTitle),
          SettingsTile(
            title: 'Schedule & Availability',
            onTap: () {
              context.push(AppRouter.availabilityScreen);
            },
          ),
          SettingsTile(title: 'Payout & Withdrawal', onTap: () {}),
          SettingsTile(
            title: 'Account Information',
            onTap: () {
              context.push(AppRouter.accountInformationScreen);
            },
          ),

          //  SettingsTile(title: 'Notifications', onTap: () {}),
          //  SettingsTile(title: 'Language', onTap: () {}),
          //  SettingsTile(title: 'Help & Support', onTap: () {}),
          //  SettingsTile(title: 'Terms & Conditions', onTap: () {}),
          //  SettingsTile(title: 'About Us', onTap: () {}),
          //  SettingsTile(title: 'Invite Friends', onTap: () {}),
          //  SettingsTile(title: 'Feedback', onTap: () {}),
          //  SettingsTile(title: 'Delete Account', onTap: () {}),
          //  SettingsTile(title: 'Logout', onTap: () {}),
          //  SettingsTile(title: 'Dark Mode', onTap: () {}),
          SettingsTile(title: 'Security & Privacy', onTap: () {}),
        ],
      ),
    );
  }
}
