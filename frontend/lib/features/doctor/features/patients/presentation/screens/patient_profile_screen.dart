import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/patients/data/models/patient_data.dart';
import 'package:medi/features/doctor/features/patients/presentation/widgets/add_patient_medication_dialog.dart';
import 'package:medi/features/doctor/features/patients/presentation/widgets/patient_health_reports_tab.dart';
import 'package:medi/features/doctor/features/patients/presentation/widgets/patient_medications_tab.dart';
import 'package:medi/features/doctor/features/patients/presentation/widgets/patient_overview_tab.dart';
import 'package:medi/features/doctor/features/patients/presentation/widgets/patient_profile_header.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({
    super.key,
    required this.patient,
    this.showAddMedicationAction = false,
  });

  final PatientData patient;
  final bool showAddMedicationAction;

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  int _selectedTabIndex = 0;

  Future<void> _openAddMedicationDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          AddPatientMedicationDialog(patientName: widget.patient.name),
    );

    if (!context.mounted || result == null) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'Prepared ${result['medicationName']} for ${widget.patient.name}',
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppSizes.w16,
                  AppSizes.h12,
                  AppSizes.w16,
                  AppSizes.h16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PatientProfileHeader(
                      patient: widget.patient,
                      selectedTabIndex: _selectedTabIndex,
                      onTabChanged: (index) {
                        setState(() {
                          _selectedTabIndex = index;
                        });
                      },
                    ),
                    SizedBox(height: AppSizes.h20),
                    if (_selectedTabIndex == 0) ...[
                      PatientOverviewTab(patient: widget.patient),
                    ],
                    if (_selectedTabIndex == 1) ...[
                      PatientMedicationsTab(
                        patient: widget.patient,
                        showAddMedicationAction: widget.showAddMedicationAction,
                        onAddMedication: _openAddMedicationDialog,
                      ),
                    ],
                    if (_selectedTabIndex == 2) ...[
                      PatientHealthReportsTab(patient: widget.patient),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(height: AppSizes.h64),
          ],
        ),
      ),
    );
  }
}
