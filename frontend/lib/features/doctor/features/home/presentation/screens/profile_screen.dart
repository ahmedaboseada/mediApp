import 'package:flutter/material.dart';
import 'package:medi/core/constants/app_sizes.dart';
import 'package:medi/features/doctor/features/home/presentation/widgets/notification_section.dart';
import 'package:medi/features/doctor/features/home/presentation/widgets/settings_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SettingsSection(),
              SizedBox(height: AppSizes.h24),
              NotificationSection(),
            ],
          ),
        ),
      ),
    );
  }
}
