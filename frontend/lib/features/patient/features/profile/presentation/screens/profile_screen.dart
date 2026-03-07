import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/home/presentation/widgets/support_section.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/account_section.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/connected_doctors_section.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/medical_records_section.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/privacy_security_section.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/settings_section.dart';
import 'package:medi/features/shared/auth/data/repo/auth_repo_impl.dart';
import 'package:medi/features/shared/auth/presentation/cubit/user_profile/user_profile_cubit.dart';
import 'package:medi/features/shared/auth/presentation/cubit/user_profile/user_profile_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserProfileCubit(getIt<AuthRepoImpl>())..getMe(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.w16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BlocBuilder<UserProfileCubit, UserProfileState>(
                    builder: (context, state) {
                      final isLoading = state is UserProfileLoading;
                      final profile = state is UserProfileLoaded
                          ? state.profile
                          : null;
                      final user = profile?.user;

                      final name = user != null
                          ? '${user.firstName} ${user.lastName}'.trim()
                          : 'Guest User';
                      final subtitle = user?.type == 'doctor'
                          ? (profile?.doctor?.specialization.isNotEmpty == true
                                ? profile!.doctor!.specialization
                                : 'No Specialty')
                          : (user?.email ?? 'Patient');
                      final image = user?.profilePicture.isNotEmpty == true
                          ? user!.profilePicture
                          : null;

                      return UserInfoScetion(
                        name: name,
                        specialty: subtitle,
                        networkImageUrl: image,
                        isLoading: isLoading,
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
      ),
    );
  }
}
