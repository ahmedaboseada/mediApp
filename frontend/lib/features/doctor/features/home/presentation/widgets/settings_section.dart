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
          SettingsTile(title: 'Account Information', onTap: () {}),
          SettingsTile(title: 'Security & Privacy', onTap: () {}),
        ],
      ),
    );
  }
}
