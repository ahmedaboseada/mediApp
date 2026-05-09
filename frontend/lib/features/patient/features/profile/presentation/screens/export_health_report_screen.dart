import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/patients/data/models/patient_data.dart';
import 'package:medi/features/patient/features/health_measurements/data/models/measurement_model.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/export_actions.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/health_report_body.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/health_report_header.dart';

class ExportHealthReportScreen extends StatelessWidget {
  ExportHealthReportScreen({super.key});
  final PatientData patient = PatientData(
    id: '1223',
    name: 'Reham Mohamed',
    age: 23,
    gender: 'female',
    bloodType: 'O+',
    status: PatientStatus.normal,
    avatarAsset: AppAssets.avatar1,
    email: 'reham.mohamed@example.com',
    phone: '+1234567890',
    measurements: [
      MeasurementModel(
        status: 'Normal',
        metric: MeasurementMetric.bloodPressure,
        icon: SvgPicture.asset(AppAssets.bloodPressureIcon),
        title: 'Blood Pressure',
        value: '120/80 mmHg',
      ),
      MeasurementModel(
        title: 'Heart Rate',
        status: 'Normal',
        value: '72 bpm',
        metric: MeasurementMetric.heartRate,
        icon: SvgPicture.asset(AppAssets.heartRateIcon),
      ),
      MeasurementModel(
        title: 'Blood Sugar',
        status: 'High',
        value: '150 mg/dL',
        metric: MeasurementMetric.bloodSugar,
        icon: SvgPicture.asset(AppAssets.bloodSugarIcon),
      ),
      MeasurementModel(
        title: 'Weight',
        status: 'Normal',
        value: '68 kg',
        metric: MeasurementMetric.bodyWeight,
        icon: SvgPicture.asset(AppAssets.weightScaleIcon),
      ),
    ],
    medications: [
      MedicationModel(
        id: 'med1',
        name: 'Atorvastatin',
        type: 'Cholesterol',
        dosage: '10 mg',
        frequency: 'Once daily',
        stock: 15,
        isChronic: true,
        status: 'Normal',
      ),
      MedicationModel(
        id: 'med2',
        name: 'Metformin',
        type: 'Diabetes',
        dosage: '500 mg',
        frequency: 'Twice daily',
        stock: 5,
        isChronic: true,
        status: 'critical',
      ),
    ],
    allergies: ['Peanuts', 'Penicillin'],
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                ),
                SizedBox(height: AppSizes.h24),
                HealthReportBody(patient: patient),
                SizedBox(height: AppSizes.h24),
                ExportActions(
                  onExport: () {
                    // Handle PDF export
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
    );
  }
}
