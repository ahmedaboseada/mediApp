import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/patients/data/models/patient_data.dart';

class MedicalRecordsSection extends StatelessWidget {
  const MedicalRecordsSection({super.key, this.patientData});

  final PatientData? patientData;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.w24),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(AppAssets.stethoscope, width: 24, height: 24),
                SizedBox(width: 8),
                Text("Medical Records", style: AppStyles.black18500),
              ],
            ),
            SizedBox(height: 20),
            ListTile(
              onTap: () => context.push(AppRouter.symptomLogScreen),
              contentPadding: EdgeInsets.zero,
              title: Text("Daily symptoms", style: AppStyles.black16400),
              trailing: Icon(Icons.arrow_forward_ios, color: AppColors.primary),
            ),
            ListTile(
              enabled: patientData != null,
              onTap: patientData == null
                  ? null
                  : () => context.push(
                        AppRouter.exportHealthReportScreen,
                        extra: patientData,
                      ),
              contentPadding: EdgeInsets.zero,
              title: Text("Export health report", style: AppStyles.black16400),
              trailing: SvgPicture.asset(
                AppAssets.export,
                width: 24,
                height: 24,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () => context.push(AppRouter.exportHealthPassportScreen),
              title: Text(
                "Export health passport",
                style: AppStyles.black16400,
              ),
              trailing: SvgPicture.asset(
                AppAssets.export,
                width: 24,
                height: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
