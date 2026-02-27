import 'package:flutter/material.dart';
import 'package:medi/core/constants/app_sizes.dart';
import 'package:medi/core/widgets/user_info_scetion.dart';
import 'package:medi/features/doctor/features/home/presentation/widgets/support_section.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/account_section.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/connected_doctors_section.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/medical_records_section.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/privacy_security_section.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/settings_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.w16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                UserInfoScetion(),
                                SizedBox(height: AppSizes.h16),

                 AccountSection(),
                SizedBox(height: AppSizes.h16),
                                SettingsSection(),
                SizedBox(height: AppSizes.h16),
                                MedicalRecordsSection(),
                SizedBox(height: AppSizes.h16),
               
                ConnectedDoctorsSection(),
                SizedBox(height: AppSizes.h16),
                PrivacySecuritySection(),
                SizedBox(height: AppSizes.h16),

                
                SupportSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
