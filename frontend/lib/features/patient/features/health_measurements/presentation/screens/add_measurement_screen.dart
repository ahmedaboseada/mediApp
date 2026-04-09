import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/health_measurements/presentation/controller/health_measurements/health_measurements_cubit.dart';
import 'package:medi/features/patient/features/health_measurements/presentation/widgets/add_measurement_content.dart';
import 'package:medi/features/patient/features/health_measurements/presentation/widgets/add_measurement_tab_selector.dart';

enum AddMeasurementTab { bloodPressure, bloodSugar, weight }

class AddMeasurementScreen extends StatefulWidget {
  const AddMeasurementScreen({
    super.key,
    this.initialTab = AddMeasurementTab.bloodPressure,
  });

  final AddMeasurementTab initialTab;

  @override
  State<AddMeasurementScreen> createState() => _AddMeasurementScreenState();
}

class _AddMeasurementScreenState extends State<AddMeasurementScreen> {
  late AddMeasurementTab _selectedTab;

  final TextEditingController _systolicController = TextEditingController();
  final TextEditingController _diastolicController = TextEditingController();
  final TextEditingController _heartRateController = TextEditingController();
  final TextEditingController _bloodGlucoseController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
  }

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _heartRateController.dispose();
    _bloodGlucoseController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(title: AppStrings.addMeasurement),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              AppSizes.w16,
              AppSizes.h8,
              AppSizes.w16,
              AppSizes.h24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                AddMeasurementTabSelector(
                  selectedTabIndex: _selectedTab.index,
                  onTabSelected: (int index) {
                    setState(() {
                      _selectedTab = AddMeasurementTab.values[index];
                    });
                  },
                ),
                SizedBox(height: AppSizes.h16),
                AddMeasurementContent(
                  selectedTabIndex: _selectedTab.index,
                  systolicController: _systolicController,
                  diastolicController: _diastolicController,
                  heartRateController: _heartRateController,
                  bloodGlucoseController: _bloodGlucoseController,
                  weightController: _weightController,
                ),
                SizedBox(height: AppSizes.h24),
                PrimaryButton(text: AppStrings.save, onPressed: _handleSave),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    final cubit = context.read<HealthMeasurementsCubit>();

    String? validationError;

    if (_selectedTab == AddMeasurementTab.bloodPressure) {
      final systolic = int.tryParse(_systolicController.text.trim());
      final diastolic = int.tryParse(_diastolicController.text.trim());
      final heartRate = int.tryParse(_heartRateController.text.trim());

      if (systolic == null || diastolic == null) {
        validationError = 'Please enter valid systolic and diastolic values';
      } else {
        final result = await cubit.addBloodPressureMeasurement(
          systolic: systolic,
          diastolic: diastolic,
          heartRate: heartRate,
        );
        result.fold(
          (error) {
            validationError = error.message;
          },
          (_) {
            Navigator.of(context).pop();
          },
        );
      }
    } else if (_selectedTab == AddMeasurementTab.bloodSugar) {
      final glucose = int.tryParse(_bloodGlucoseController.text.trim());
      if (glucose == null) {
        validationError = 'Please enter a valid blood sugar value';
      } else {
        final result = await cubit.addBloodSugarMeasurement(value: glucose);
        result.fold(
          (error) {
            validationError = error.message;
          },
          (_) {
            Navigator.of(context).pop();
          },
        );
      }
    } else {
      final weight = double.tryParse(_weightController.text.trim());
      if (weight == null) {
        validationError = 'Please enter a valid weight value';
      } else {
        final result = await cubit.addWeightMeasurement(value: weight);
        result.fold(
          (error) {
            validationError = error.message;
          },
          (_) {
            Navigator.of(context).pop();
          },
        );
      }
    }

    if (validationError != null && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(validationError!)));
    }
  }
}
