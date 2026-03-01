import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/section_item_tile.dart';

class PrivacySecuritySection extends StatefulWidget {
  const PrivacySecuritySection({super.key});

  @override
  State<PrivacySecuritySection> createState() => _PrivacySecuritySectionState();
}

class _PrivacySecuritySectionState extends State<PrivacySecuritySection> {
  bool twoFactorAuth = false;

  void _showTwoFactorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        clipBehavior: Clip.hardEdge,
        constraints: BoxConstraints(
          maxWidth: double.infinity,
        ),
        insetPadding: EdgeInsets.all(AppSizes.w16),
        backgroundColor: AppColors.whiteText,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.r40),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.w24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                'Enable Two-Factor Authentication?',
                style: AppStyles.black24700,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.h16),
              
              // Message
              Text(
                "For added security, we'll send a verification link to your email.",
                style: AppStyles.tertiary14400,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.h32),
              
              // Send Email Button
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      onPressed: () {
                        setState(() {
                          twoFactorAuth = true;
                        });
                        Navigator.pop(context);
                      },
                      text: 'Send Email',
                    ),
                  ),
                  SizedBox(width: AppSizes.h12),
                  
                  // Cancel Button
                  Expanded(
                    child: SecondryButton(
                      onPressed: () {
                        setState(() {
                          twoFactorAuth = false;
                        });
                        Navigator.pop(context);
                      },
                      text: 'Cancel',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

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
            SectionItemTile(
              title: "Change Email",
              onTap: () => context.push(AppRouter.changeEmailScreen),
            ),
            SectionItemTile(
              title: 'Change Password',
              onTap: () => context.push(AppRouter.changePasswordScreen),
            ),
            ToggleTile(
              title: "Two-Factor Authentication",
              subtitle: 'Add an extra layer of security',
              value: twoFactorAuth,
              onChanged: (bool value) {
                _showTwoFactorDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
