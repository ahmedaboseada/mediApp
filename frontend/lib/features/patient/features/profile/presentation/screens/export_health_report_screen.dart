import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/profile/presentation/controller/health_report_export/health_report_export_cubit.dart';
import 'package:medi/features/patient/features/profile/presentation/controller/health_report_export/health_report_export_state.dart';
import 'package:medi/features/doctor/features/patients/data/models/patient_data.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/export_actions.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/health_report_body.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/health_report_header.dart';
import 'package:open_filex/open_filex.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:medi/features/patient/features/profile/data/repo/profile_repo.dart';
import 'package:medi/features/patient/features/profile/presentation/controller/health_passport_export/health_passport_export_cubit.dart';
import 'package:medi/features/patient/features/profile/presentation/controller/health_passport_export/health_passport_export_state.dart';

class ExportHealthReportScreen extends StatelessWidget {
  const ExportHealthReportScreen({super.key, required this.patient});

  final PatientData patient;

  bool get _hasNetworkImage => patient.avatarAsset.startsWith('http');
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HealthReportExportCubit>(),
      child: Builder(
        builder: (context) {
          return BlocListener<HealthReportExportCubit, HealthReportExportState>(
            listener: (context, state) async {
              if (state is HealthReportExportLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );
                return;
              }

              if (Navigator.canPop(context)) Navigator.pop(context);

              if (state is HealthReportExportFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Export failed: ${state.error}')),
                );
              }

              if (state is HealthReportExportSuccess) {
                try {
                  await OpenFilex.open(state.filePath);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Saved to ${state.filePath}')),
                  );
                } catch (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not open downloaded PDF')),
                  );
                }
              }
            },
            child: Scaffold(
              appBar: CustomAppBar(),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.w16,
                      vertical: AppSizes.h24,
                    ),
                    child: Column(
                      children: [
                        HealthReportHeader(
                          name: patient.name,
                          gender: patient.gender,
                          age: patient.age.toString(),
                          networkImageUrl:
                              _hasNetworkImage ? patient.avatarAsset : null,
                          localImagePath:
                              _hasNetworkImage ? null : patient.avatarAsset,
                        ),
                        SizedBox(height: AppSizes.h24),
                        HealthReportBody(patient: patient),
                        SizedBox(height: AppSizes.h24),
                        ExportActions(
                          onExport: () {
                            context
                                .read<HealthReportExportCubit>()
                                .exportHealthReport(
                                  apiEndpoint: '/export/patient-record',
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
                  'Health Report QR Code',
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
                  'Share this QR code with your doctor to access your health report',
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
