import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/services/accessibility_service.dart';
import 'package:medi/core/widgets/common/app_button.dart';
import 'package:medi/features/doctor/features/home/presentation/widgets/support_section.dart';
import 'package:medi/features/patient/features/profile/presentation/mappers/auth_response_model_mapper.dart';
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

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _announced = false;
  bool _isTestingRefreshToken = false;

  @override
  Widget build(BuildContext context) {
    if (!_announced) {
      _announced = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AccessibilityService.announceWithRTL('Profile screen');
      });
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UserProfileCubit(getIt<AuthRepoImpl>())..getMe()),
        BlocProvider(create: (_) => getIt<ConnectedDoctorsCubit>()..loadConnectedDoctors()),
      ],
      child: Builder(
        builder: (innerContext) {
          return Scaffold(
            extendBody: true,
            body: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.all(AppSizes.w16),
                child: RefreshIndicator(
                  onRefresh: () => _refreshProfile(innerContext),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
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
                              fcmToken: user?.fcmToken,
                            );
                          },
                        ),
                        SizedBox(height: AppSizes.h16),

                        AccountSection(),
                        SizedBox(height: AppSizes.h16),
                        SettingsSection(),
                        SizedBox(height: AppSizes.h16),
                        BlocBuilder<UserProfileCubit, UserProfileState>(
                          builder: (context, state) {
                            return MedicalRecordsSection(
                              patientData: state.profile?.toPatientData(),
                            );
                          },
                        ),
                        SizedBox(height: AppSizes.h16),
                        const ConnectedDoctorsSection(),
                        SizedBox(height: AppSizes.h16),
                        PrivacySecuritySection(),
                        SizedBox(height: AppSizes.h16),

                        // AppButton(
                        //   isLoading: _isTestingRefreshToken,
                        //   onPressed: () async {
                        //     setState(() {
                        //       _isTestingRefreshToken = true;
                        //     });

                            // final success = await getIt<ApiService>()
                            //     .dioClient
                            //     .testRefreshToken();

                            // if (!mounted) {
                            //   return;
                            // }

                        //     setState(() {
                        //       _isTestingRefreshToken = false;
                        //     });

                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       SnackBar(
                        //         content: Text(
                        //           success
                        //               ? 'Refresh token test succeeded'
                        //               : 'Refresh token test failed',
                        //         ),
                        //       ),
                        //     );
                        //   },
                        //   text: 'Test Refresh Token',
                        // ),

                       // SizedBox(height: AppSizes.h16),

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
        },
      ),
    );
  }

  Future<void> _refreshProfile(BuildContext context) async {
    await Future.wait([
      context.read<UserProfileCubit>().getMe(),
      context.read<ConnectedDoctorsCubit>().loadConnectedDoctors(),
    ]);
  }
}
