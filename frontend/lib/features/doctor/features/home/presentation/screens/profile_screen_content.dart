import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/home/presentation/widgets/connected_patients_section.dart';
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

/// Displays the profile content sections.
/// This widget is responsible only for rendering the UI structure.
/// All side effects and state management are handled by listeners in the parent.
class ProfileScreenContent extends StatelessWidget {
  const ProfileScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.w16),
          child: Column(
            children: [
              const _UserHeaderSection(),
              SizedBox(height: AppSizes.h24),
              const ConnectedPatientsSection(),
              SizedBox(height: AppSizes.h24),
              const _SettingsSectionWrapper(),
              SizedBox(height: AppSizes.h24),
              const NotificationSection(),
              SizedBox(height: AppSizes.h24),
              const _PrivacySecuritySectionWrapper(),
              SizedBox(height: AppSizes.h24),
              const SupportSection(),
              SizedBox(height: AppSizes.h24),
              const _LogOutSectionWrapper(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Displays the user header with name, specialty, and avatar.
/// Listens to UserProfileCubit state to extract and format user data.
class _UserHeaderSection extends StatelessWidget {
  const _UserHeaderSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileCubit, UserProfileState>(
      buildWhen: (previous, current) =>
          (previous.profile?.user != current.profile?.user ||
          previous is UserProfileLoading ||
          current is UserProfileLoading),
      builder: (context, state) {
        final isLoading = state is UserProfileLoading;
        final profile = state.profile;
        final user = profile?.user;

        final name = user != null
            ? '${user.firstName} ${user.lastName}'.trim()
            : 'Guest User';
        final specialty = profile?.doctor?.specialization.isNotEmpty == true
            ? profile!.doctor!.specialization
            : 'No Specialty';
        final imageUrl = user?.profilePicture.isNotEmpty == true
            ? user!.profilePicture
            : null;

        return UserInfoScetion(
          name: name,
          specialty: specialty,
          networkImageUrl: imageUrl,
          isLoading: isLoading,
          userId: profile?.user.id ?? '',
          fcmToken: user?.fcmToken,

        );
      },
    );
  }
}

/// Wrapper for SettingsSection that only renders when doctor data is available.
class _SettingsSectionWrapper extends StatelessWidget {
  const _SettingsSectionWrapper();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileCubit, UserProfileState>(
      buildWhen: (previous, current) =>
          previous.profile?.doctor != current.profile?.doctor,
      builder: (context, state) {
        final doctor = state.profile?.doctor;
        if (doctor == null) {
          return const SizedBox.shrink();
        }
        return SettingsSection(doctor: doctor);
      },
    );
  }
}

/// Wrapper for PrivacySecuritySection with its own ProfileCubit.
class _PrivacySecuritySectionWrapper extends StatelessWidget {
  const _PrivacySecuritySectionWrapper();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(getIt<ProfileRepo>()),
      child: const PrivacySecuritySection(),
    );
  }
}

/// Wrapper for LogOutTile with its own LogOutCubit and listener for side effects.
class _LogOutSectionWrapper extends StatelessWidget {
  const _LogOutSectionWrapper();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LogOutCubit(getIt<AuthRepoImpl>()),
      child: const _LogOutSection(),
    );
  }
}

/// Displays the log out tile with listener for navigation and error handling.
class _LogOutSection extends StatelessWidget {
  const _LogOutSection();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogOutCubit, LogOutState>(
      listenWhen: (previous, current) =>
          current is LogOutSuccess || current is LogOutFailure,
      listener: (context, state) {
        if (state is LogOutSuccess) {
          context.go(AppRouter.selectScreen);
        } else if (state is LogOutFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: const LogOutTile(),
    );
  }
}
