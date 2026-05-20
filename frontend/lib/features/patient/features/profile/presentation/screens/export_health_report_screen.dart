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
                            // Handle QR code display
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
}
