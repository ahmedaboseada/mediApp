import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/section_item_tile.dart';
import 'package:medi/features/shared/auth/presentation/cubit/log_out/log_out_cubit.dart';

class SettingsSection extends StatefulWidget {
  const SettingsSection({super.key});

  @override
  State<SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<SettingsSection> {
  bool notifications = false;
  bool earlyVoiceAlerts = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogOutCubit, LogOutState>(
      listener: (context, state) {
        if (state is LogOutSuccess) {
          context.go(AppRouter.selectScreen);
        } else if (state is LogOutFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        final isLoading = state is LogOutLoading;

        return Card(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.w16),
            child: Column(
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
                      style: AppStyles.black14500.copyWith(
                        fontSize: AppSizes.sp18,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SectionItemTile(
                  title: 'Account Information',
                  onTap: () {
                    context.push(AppRouter.patientAccountInfoScreen);
                  },
                ),
                ToggleTile(
                  title: 'Notifications',
                  value: notifications,
                  onChanged: (value) {
                    setState(() {
                      notifications = value;
                    });
                  },
                ),
                ToggleTile(
                  title: 'Early Voice Alerts',
                  value: earlyVoiceAlerts,
                  onChanged: (value) {
                    setState(() {
                      earlyVoiceAlerts = value;
                    });
                  },
                ),
                SectionItemTile(
                  title: 'Logout',
                  trailingIcon: isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.primary,
                          size: 16,
                        ),
                  onTap: isLoading
                      ? null
                      : () {
                          context.read<LogOutCubit>().logOut();
                        },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
