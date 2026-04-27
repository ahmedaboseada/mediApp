import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/home/presentation/widgets/notification_section.dart';
import 'package:medi/features/doctor/features/home/presentation/widgets/settings_section.dart';
import 'package:medi/features/doctor/features/home/presentation/widgets/support_section.dart';
import 'package:medi/features/patient/features/profile/data/repo/profile_repo.dart';
import 'package:medi/features/patient/features/profile/presentation/controller/profile/profile_cubit.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/log_out_tile.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/privacy_security_section.dart';
import 'package:medi/features/shared/auth/data/repo/auth_repo_impl.dart';
import 'package:medi/features/shared/auth/presentation/cubit/log_out/log_out_cubit.dart';
import 'package:medi/features/shared/auth/presentation/cubit/user_profile/user_profile_cubit.dart';
import 'package:medi/features/shared/auth/presentation/cubit/user_profile/user_profile_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserProfileCubit(getIt<AuthRepoImpl>())..getMe(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(AppSizes.w16),
              child: Column(
                children: [
                  BlocBuilder<UserProfileCubit, UserProfileState>(
                    builder: (context, state) {
                      final isLoading = state is UserProfileLoading;
                      final profile = state.profile;
                      final user = profile?.user;

                      final name = user != null
                          ? '${user.firstName} ${user.lastName}'.trim()
                          : 'Guest User';
                      final subtitle =
                          profile?.doctor?.specialization.isNotEmpty == true
                          ? profile!.doctor!.specialization
                          : 'No Specialty';
                      final image = user?.profilePicture.isNotEmpty == true
                          ? user!.profilePicture
                          : null;

                      return UserInfoScetion(
                        name: name,
                        specialty: subtitle,
                        networkImageUrl: image,
                        isLoading: isLoading,
                        userId: profile?.user.id ?? '',
                      );
                    },
                  ),
                  SizedBox(height: AppSizes.h24),
                  SettingsSection(
                    doctor: context
                        .read<UserProfileCubit>()
                        .state
                        .profile!
                        .doctor!,
                  ),
                  SizedBox(height: AppSizes.h24),
                  NotificationSection(),
                  SizedBox(height: AppSizes.h24),
                  BlocProvider(
                    create: (context) => ProfileCubit(getIt<ProfileRepo>()),
                    child: PrivacySecuritySection(),
                  ),
                  SizedBox(height: AppSizes.h24),
                  SupportSection(),
                  SizedBox(height: AppSizes.h24),
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
                        return LogOutTile();
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
}
