import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/section_item_tile.dart';

class PrivacySecuritySection extends StatefulWidget {
  const PrivacySecuritySection({super.key});

  @override
  State<PrivacySecuritySection> createState() => _PrivacySecuritySectionState();
}

class _PrivacySecuritySectionState extends State<PrivacySecuritySection> {
  bool twoFactorAuth = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding:  EdgeInsets.all(AppSizes.w24),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  AppAssets.settings,
                  height: AppSizes.h20,
                  width: AppSizes.w20,
                ),
                SizedBox(width: 8),
                Text("Privacy & Security",style: AppStyles.black18500,),
              ],
            ),
            SizedBox(height: 20),
            SectionItemTile(title: "Change Email"),
            SectionItemTile(
              title: 'Change Password',
            ),
            ToggleTile(
              title: "Two-Factor Authentication",
              subtitle: 'Add an extra layer of security',
              value: twoFactorAuth,
              onChanged: (bool value) {
                setState(() {
                  twoFactorAuth = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
