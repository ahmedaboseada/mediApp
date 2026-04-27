import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/home/presentation/widgets/support_section.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/account_section.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/connected_doctors_section.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/log_out_tile.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/medical_records_section.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/privacy_security_section.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/settings_section.dart';
import 'package:medi/features/shared/auth/data/repo/auth_repo_impl.dart';
import 'package:medi/features/shared/auth/presentation/cubit/user_profile/user_profile_cubit.dart';
import 'package:medi/features/shared/auth/presentation/cubit/user_profile/user_profile_state.dart';

import 'package:medi/features/patient/features/doctors/presentation/cubits/connected_doctors_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserProfileCubit(getIt<AuthRepoImpl>())..getMe(),
      child: Scaffold(
        extendBody: true,
        body: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.all(AppSizes.w16),
            child: SingleChildScrollView(
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
                      final subtitle = (user?.email ?? 'Patient');
                      final image = user?.profilePicture.isNotEmpty == true
                          ? user!.profilePicture
                          : null;

                      return UserInfoScetion(
                        name: name,
                        specialty: subtitle,
                        networkImageUrl: image,
                        isLoading: isLoading,
                        userId: profile?.patient?.patientId ?? '',
                      );
                    },
                  ),
                  SizedBox(height: AppSizes.h16),

                  AccountSection(),
                  SizedBox(height: AppSizes.h16),
                  SettingsSection(),
                  SizedBox(height: AppSizes.h16),
                  MedicalRecordsSection(),
                  SizedBox(height: AppSizes.h16),

                  BlocProvider(
                    create: (context) =>
                        getIt<ConnectedDoctorsCubit>()..loadConnectedDoctors(),
                    child: const ConnectedDoctorsSection(),
                  ),
                  SizedBox(height: AppSizes.h16),
                  PrivacySecuritySection(),
                  SizedBox(height: AppSizes.h16),

                  SupportSection(),
                  SizedBox(height: AppSizes.h16),
                  LogOutTile(),
                  SizedBox(height: AppSizes.h120),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
