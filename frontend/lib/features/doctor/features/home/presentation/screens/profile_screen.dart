import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/home/presentation/widgets/notification_section.dart';
import 'package:medi/features/doctor/features/home/presentation/widgets/settings_section.dart';
import 'package:medi/features/doctor/features/home/presentation/widgets/support_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding:  EdgeInsets.all(AppSizes.w16),
            child: Column(
              children: [
                UserInfoScetion(),
                SizedBox(height: AppSizes.h24),
                SettingsSection(),
                SizedBox(height: AppSizes.h24),
                NotificationSection(),
                SizedBox(height: AppSizes.h24),
                 SupportSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
