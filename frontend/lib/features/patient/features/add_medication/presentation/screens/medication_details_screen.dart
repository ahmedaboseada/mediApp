import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medication_data_cubit.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medication_data_state.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/custom_stepper.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/navigation_buttons.dart';

class MedicationDetailsScreen extends StatefulWidget {
  const MedicationDetailsScreen({super.key});

  @override
  State<MedicationDetailsScreen> createState() =>
      _MedicationDetailsScreenState();
}

class _MedicationDetailsScreenState extends State<MedicationDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _medicationNameController = TextEditingController();
  final _dosageController = TextEditingController();
  String? _selectedType;

  final List<String> _medicationTypes = [
    'Tablet',
    'Capsule',
    'Syrup',
    'Injection',
    'Drop',
    'Cream',
    'Ointment',
    'Inhaler',
  ];

  @override
  void dispose() {
    _medicationNameController.dispose();
    _dosageController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      if (_selectedType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select medication type'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      context.read<MedicationDataCubit>().updateMedicationDetails(
        medicationName: _medicationNameController.text,
        type: _selectedType!,
        dosage: _dosageController.text,
      );

      context.push('/medicine/schedule');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicationDataCubit, MedicationDataState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.primaryText,
              ),
              onPressed: () => context.pop(),
            ),
            title: Text(
              'Add Medication',
              style: AppStyles.black16400.copyWith(fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.w16,
                  vertical: AppSizes.h16,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Progress Stepper
                      CustomStepper(
                        currentStep: 2,
                        title: 'Medication Details',
                      ),
                      SizedBox(height: AppSizes.h32),

                      // Medication Name Field
                      CustomTextField(
                        label: 'Medication Name',
                        hintText: 'e.g, Aspirin',
                        controller: _medicationNameController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter medication name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSizes.h16),

                      // Type Dropdown
                      CustomDropdown(
                        label: 'Type',
                        hint: 'Select type',
                        items: _medicationTypes,
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value;
                          });
                        },
                      ),
                      SizedBox(height: AppSizes.h16),

                      // Dosage Field
                      CustomTextField(
                        label: 'Dosage',
                        hintText: 'e.g, 100mg',
                        controller: _dosageController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter dosage';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSizes.h32),

                      NavigationButtons(
                        onBackPressed: () => context.pop(),
                        nextEnabled: true,
                        onNextPressed: _handleNext,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
