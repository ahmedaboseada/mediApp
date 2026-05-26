import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/services/accessibility_service.dart';
import 'package:medi/features/patient/features/profile/presentation/controller/profile/profile_cubit.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/section_item_tile.dart';

class PrivacySecuritySection extends StatefulWidget {
  const PrivacySecuritySection({super.key});

  @override
  State<PrivacySecuritySection> createState() => _PrivacySecuritySectionState();
}

class _PrivacySecuritySectionState extends State<PrivacySecuritySection> {
  bool twoFactorAuth = false;
  bool? pendingToggleAction;

  @override
  void initState() {
    super.initState();
    _loadTwoFactorStatus();
  }

  void _loadTwoFactorStatus() async {
    final enabled = HiveService.isTwoFactorEnabled();
    setState(() {
      twoFactorAuth = enabled;
    });
  }

  void _showTwoFactorDialog(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>();
    AccessibilityService.announceDialog(
      'Enable two-factor authentication',
      'For added security, a verification link will be sent to your email.',
    );

    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: profileCubit,
        child: Dialog(
          clipBehavior: Clip.hardEdge,
          constraints: BoxConstraints(maxWidth: double.infinity),
          insetPadding: EdgeInsets.all(AppSizes.w16),
          backgroundColor: AppColors.whiteText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.r40),
          ),
          child: Semantics(
            namesRoute: true,
            label: 'Enable two-factor authentication dialog',
            child: Padding(
              padding: EdgeInsets.all(AppSizes.w24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Enable Two-Factor Authentication?',
                    style: AppStyles.black24700,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSizes.h16),
                  Text(
                    "For added security, we'll send a verification link to your email.",
                    style: AppStyles.tertiary14400,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSizes.h32),
                  BlocListener<ProfileCubit, ProfileState>(
                    listener: (context, state) {
                      if (state is ToggleTwoFactorAuthSuccess) {
                        Navigator.pop(context);
                      } else if (state is ToggleTwoFactorAuthFailure) {
                        Navigator.pop(context);
                      }
                    },
                    child: BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        return Row(
                          children: [
                            Expanded(
                              child: BlocBuilder<ProfileCubit, ProfileState>(
                                builder: (context, state) {
                                  final isLoading =
                                      state is ToggleTwoFactorAuthLoading;
                                  return PrimaryButton(
                                    onPressed: isLoading
                                        ? null
                                        : () {
                                            context
                                                .read<ProfileCubit>()
                                                .toggleTwoFactorAuth(true);
                                          },
                                    text: 'Enable',
                                    child: isLoading
                                        ? SizedBox(
                                            height: AppSizes.h20,
                                            width: AppSizes.h20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    AppColors.whiteText,
                                                  ),
                                            ),
                                          )
                                        : null,
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: AppSizes.h12),
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
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleToggleTwoFactor(BuildContext context, bool value) {
    final profileCubit = context.read<ProfileCubit>();

    setState(() {
      twoFactorAuth = value;
    });

    if (value) {
      pendingToggleAction = true;
      _showTwoFactorDialog(context);
    } else {
      pendingToggleAction = false;
      profileCubit.toggleTwoFactorAuth(false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Disabling Two-Factor Authentication...'),
          backgroundColor: Colors.blue,
        ),
      );
      AccessibilityService.announceLoading('Disabling two-factor authentication');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ToggleTwoFactorAuthSuccess) {
          pendingToggleAction = null;
          if (twoFactorAuth) {
            HiveService.setTwoFactorEnabled(true);
          } else {
            HiveService.setTwoFactorEnabled(false);
          }
          AccessibilityService.announceSuccess('Two-factor authentication updated');
        } else if (state is ToggleTwoFactorAuthFailure) {
          setState(() {
            twoFactorAuth = !twoFactorAuth;
            pendingToggleAction = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
          AccessibilityService.announceError(state.message);
        }
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.w24),
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
                  Text("Privacy & Security", style: AppStyles.black18500),
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
                  _handleToggleTwoFactor(context, value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
