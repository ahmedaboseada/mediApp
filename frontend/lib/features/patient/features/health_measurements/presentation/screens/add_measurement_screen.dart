import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
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

  void _handleSave() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${AppStrings.addMeasurement} ${AppStrings.save.toLowerCase()}d',
        ),
      ),
    );
  }
}
