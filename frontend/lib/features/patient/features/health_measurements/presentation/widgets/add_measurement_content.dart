import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/health_measurements/presentation/widgets/add_measurement_info_card.dart';
import 'package:medi/features/patient/features/health_measurements/presentation/widgets/add_measurement_input_field.dart';

class AddMeasurementContent extends StatelessWidget {
  const AddMeasurementContent({
    super.key,
    required this.selectedTabIndex,
    required this.systolicController,
    required this.diastolicController,
    required this.heartRateController,
    required this.bloodGlucoseController,
    required this.weightController,
  });

  final int selectedTabIndex;
  final TextEditingController systolicController;
  final TextEditingController diastolicController;
  final TextEditingController heartRateController;
  final TextEditingController bloodGlucoseController;
  final TextEditingController weightController;

  @override
  Widget build(BuildContext context) {
    return switch (selectedTabIndex) {
      0 => Column(
        children: <Widget>[
          AddMeasurementInputField(
            label: '${AppStrings.systolic} (mmHg)',
            hintText: 'e.g, 120',
            controller: systolicController,
          ),
          SizedBox(height: AppSizes.h16),
          AddMeasurementInputField(
            label: '${AppStrings.diastolic} (mmHg)',
            hintText: 'e.g, 80',
            controller: diastolicController,
          ),
          SizedBox(height: AppSizes.h16),
          AddMeasurementInputField(
            label: AppStrings.heartRate,
            hintText: 'e.g, 80',
            controller: heartRateController,
          ),
          SizedBox(height: AppSizes.h16),
          AddMeasurementInfoCard(
            title: AppStrings.normalRange,
            lines: const <String>[
              'Blood pressure around 120/80',
              'Heart rate 60-100 bpm',
            ],
          ),
        ],
      ),
      1 => Column(
        children: <Widget>[
          AddMeasurementInputField(
            label: '${AppStrings.bloodGlucose} (mg/dL)',
            hintText: 'e.g, 75',
            controller: bloodGlucoseController,
          ),
          SizedBox(height: AppSizes.h16),
          AddMeasurementInfoCard(
            title: AppStrings.normalRange,
            lines: const <String>[
              'Fasting: 70-100 mg/dL',
              'After meal: < 140 mg/dL',
            ],
          ),
        ],
      ),
      _ => Column(
        children: <Widget>[
          AddMeasurementInputField(
            label: 'Weight (Kg)',
            hintText: 'e.g, 120',
            controller: weightController,
          ),
          SizedBox(height: AppSizes.h16),
          AddMeasurementInfoCard(
            title: AppStrings.tips,
            lines: const <String>[
              '• Weigh yourself at the same time each day',
              '• Use the same scale for consistency',
            ],
          ),
        ],
      ),
    };
  }
}
