import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/home/presentation/widgets/settings_tile.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/section_item_tile.dart';
import 'package:medi/features/shared/auth/data/repo/auth_repo_impl.dart';
import 'package:medi/features/shared/auth/presentation/cubit/log_out/log_out_cubit.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

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
                context.push(AppRouter.availabilityScreen);
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
             BlocProvider(
                      create: (_) => LogOutCubit(getIt<AuthRepoImpl>()),
                    
              child: BlocConsumer<LogOutCubit, LogOutState>(
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
                  
                  return SectionItemTile(
                        title: 'Logout',
                        trailingIcon:  const Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.primary,
                                size: 16,
                              ),
                        onTap: () {
                                context.read<LogOutCubit>().logOut();
                              },
                      );
                }
              ),
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
      ),
    );
  }
}
