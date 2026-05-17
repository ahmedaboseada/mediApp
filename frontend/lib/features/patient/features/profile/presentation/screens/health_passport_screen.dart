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
import 'package:open_filex/open_filex.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:medi/features/patient/features/profile/data/repo/profile_repo.dart';

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
                            if (exportState is HealthPassportExportLoading) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                              return;
                            }

                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }

                            if (exportState
                                is HealthPassportExportSuccess) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Health passport exported successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              OpenFilex.open(exportState.filePath);
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
                                    apiEndpoint: '/export/health-passport',
                                  );
                            },
                            onShowQR: () {
                              showDialog(
                                context: context,
                                builder: (_) => BlocProvider(
                                  create: (_) => QRTokenCubit(
                                    getIt<ProfileRepo>(),
                                  )..generateQRToken(),
                                  child: _buildQRDialog(context),
                                ),
                              );
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

  Widget _buildQRDialog(BuildContext context) {
    return BlocConsumer<QRTokenCubit, QRTokenState>(
      listener: (context, state) {
        if (state is QRTokenFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to generate QR: ${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.r16),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppSizes.w24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Health Passport QR Code',
                  style: AppStyles.black18500,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSizes.h16),
                if (state is QRTokenLoading)
                  const SizedBox(
                    height: 200,
                    width: 200,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (state is QRTokenSuccess)
                  QrImageView(
                    data: state.qrToken,
                    version: QrVersions.auto,
                    size: 200.0,
                    gapless: false,
                  )
                else
                  const SizedBox(
                    height: 200,
                    width: 200,
                    child: Center(
                      child: Text('Failed to load QR code'),
                    ),
                  ),
                SizedBox(height: AppSizes.h16),
                Text(
                  'Share this QR code with your doctor to access your health passport',
                  style: AppStyles.secondary12400,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSizes.h24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                    if (state is QRTokenSuccess)
                      ElevatedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text('Regenerate'),
                        onPressed: () {
                          context.read<QRTokenCubit>().generateQRToken();
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
