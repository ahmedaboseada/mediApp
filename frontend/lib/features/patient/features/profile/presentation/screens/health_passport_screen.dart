import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/profile/presentation/controller/health_passport_export/health_passport_export_cubit.dart';
import 'package:medi/features/patient/features/profile/presentation/controller/health_passport_export/health_passport_export_state.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/health_passport_card.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/export_actions.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/health_passport_section.dart';
import 'package:medi/features/shared/auth/data/models/auth_response_model.dart';
import 'package:medi/features/shared/auth/data/repo/auth_repo_impl.dart';
import 'package:medi/features/shared/auth/presentation/cubit/user_profile/user_profile_cubit.dart';
import 'package:medi/features/shared/auth/presentation/cubit/user_profile/user_profile_state.dart';

class HealthPassportScreen extends StatelessWidget {
  const HealthPassportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserProfileCubit(getIt<AuthRepoImpl>())..getMe(),
      child: BlocProvider(
        create: (_) => getIt<HealthPassportExportCubit>(),
        child: Scaffold(
          appBar: CustomAppBar(),
          body: SafeArea(
            child: BlocBuilder<UserProfileCubit, UserProfileState>(
              builder: (context, state) {
                if (state is UserProfileLoading || state is UserProfileInitial) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is UserProfileError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(state.message, textAlign: TextAlign.center),
                        SizedBox(height: AppSizes.h16),
                        PrimaryButton(
                          text: 'Retry',
                          onPressed: () =>
                              context.read<UserProfileCubit>().getMe(),
                        ),
                      ],
                    ),
                  );
                }

                final profile = state.profile;
                final user = profile?.user;
                final patient = profile?.patient;

                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.w16,
                      vertical: AppSizes.h24,
                    ),
                    child: Column(
                      children: [
                        HealthPassportCard(
                          identity: _fullName(user),
                          dateOfBirth: user?.dob ?? 'N/A',
                          bloodGroup: _bloodGroup(profile),
                        ),
                        SizedBox(height: AppSizes.h16),
                        HealthPassportSection(
                          title: 'Allergies',
                          children: _buildChips(
                            patient?.allergies ?? const <String>[],
                            emptyText: 'No allergies found',
                          ),
                        ),
                        SizedBox(height: AppSizes.h16),
                        HealthPassportSection(
                          title: 'Medications',
                          children: _buildChips(
                            patient?.medications
                                    .map(
                                      (m) =>
                                          '${m.name}${m.dosage.isNotEmpty ? ' ${m.dosage}' : ''}',
                                    )
                                    .toList() ??
                                const <String>[],
                            emptyText: 'No medications found',
                          ),
                        ),
                        SizedBox(height: AppSizes.h16),
                        HealthPassportSection(
                          title: 'Conditions',
                          children: _buildChips(
                            patient?.chronicConditions ?? const <String>[],
                            emptyText: 'No conditions found',
                          ),
                        ),
                        SizedBox(height: AppSizes.h16),
                        HealthPassportSection(
                          title: 'Emergency Contacts',
                          children: patient?.emergencyContact != null
                              ? [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: AppSizes.w8,
                                        bottom: AppSizes.h8),
                                    child: Chip(
                                      label: Text(
                                          patient!.emergencyContact!.phone),
                                      backgroundColor: AppColors.background,
                                      side: BorderSide(
                                          color: AppColors.primary
                                              .withOpacity(0.15)),
                                      labelStyle: AppStyles.primaryDark12400,
                                    ),
                                  ),
                                ]
                              : _buildChips(
                                  patient?.caregiver?.giving ??
                                      const <String>[],
                                  emptyText: 'No emergency contacts found',
                                ),
                        ),
                        SizedBox(height: AppSizes.h24),
                        BlocListener<HealthPassportExportCubit,
                            HealthPassportExportState>(
                          listener: (context, exportState) {
                            if (exportState
                                is HealthPassportExportSuccess) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Health passport exported successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else if (exportState
                                is HealthPassportExportFailure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Failed to export: ${exportState.error}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          child: ExportActions(
                            onExport: () {
                              context
                                  .read<HealthPassportExportCubit>()
                                  .exportHealthPassport(
                                    apiEndpoint:
                                        'https://your-api.com/health-passport/export',
                                  );
                            },
                            onShowQR: () {
                              // Handle QR code display
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String _fullName(dynamic user) {
    if (user == null) return 'Guest User';
    final name = '${user.firstName} ${user.lastName}'.trim();
    return name.isEmpty ? 'Guest User' : name;
  }

  String _bloodGroup(AuthResponseModel? profile) {
    return 'N/A';
  }

  List<Widget> _buildChips(List<String> items, {required String emptyText}) {
    if (items.isEmpty) {
      return [Text(emptyText, style: AppStyles.secondary12400)];
    }

    return items
        .map(
          (item) => Padding(
            padding: EdgeInsets.only(right: AppSizes.w8, bottom: AppSizes.h8),
            child: Chip(
              label: Text(item),
              backgroundColor: AppColors.background,
              side: BorderSide(color: AppColors.primary.withOpacity(0.15)),
              labelStyle: AppStyles.primaryDark12400,
            ),
          ),
        )
        .toList();
  }
}
