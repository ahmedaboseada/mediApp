import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medication_data_cubit.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/custom_stepper.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/method_card.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/navigation_buttons.dart';

class ChooseMethodScreen extends StatefulWidget {
  const ChooseMethodScreen({super.key});

  @override
  State<ChooseMethodScreen> createState() => _ChooseMethodScreenState();
}

class _ChooseMethodScreenState extends State<ChooseMethodScreen> {
  int?
  _selectedMethod; // 0: Manual Entry, 1: Scan Prescription, 2: Scan Barcode

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
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
              // style: AppStyles.screenTitle,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Progress Stepper
                    CustomStepper(currentStep: 1, title: 'Choose Method'),
                    SizedBox(height: AppSizes.h32),

                    // Title
                    Text(
                      'How would you like to add your medication?',
                      style: AppStyles.black16400.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: AppSizes.h16),

                    // Method Options
                    // Manual Entry
                    MethodCard(
                      index: 0,
                      iconPath: AppAssets.manual,
                      title: 'Manual Entry',
                      subtitle: 'Enter details manually',
                      isSelected: _selectedMethod == 0,
                      onTap: () {
                        setState(() {
                          _selectedMethod = 0;
                        });
                      },
                    ),
                    SizedBox(height: AppSizes.h16),

                    // Scan Prescription (OCR)
                    MethodCard(
                      index: 1,
                      iconPath: AppAssets.ocr,
                      title: 'Scan Prescription (OCR)',
                      subtitle: 'Take a photo of your prescription',
                      isSelected: _selectedMethod == 1,
                      onTap: () {
                        setState(() {
                          _selectedMethod = 1;
                        });
                      },
                    ),
                    SizedBox(height: AppSizes.h16),

                    // Scan Barcode
                    MethodCard(
                      index: 2,
                      iconPath: AppAssets.barcode,
                      title: 'Scan Barcode',
                      subtitle: 'Scan medication package barcode',
                      isSelected: _selectedMethod == 2,
                      onTap: () {
                        setState(() {
                          _selectedMethod = 2;
                        });
                      },
                    ),
                    SizedBox(height: AppSizes.h32),

                    // Back and Next Buttons
                    NavigationButtons(
                      onBackPressed: () => context.pop(),
                      nextEnabled: _selectedMethod != null,
                      onNextPressed: _selectedMethod != null
                          ? () {
                              final cubit = context.read<MedicationDataCubit>();
                              cubit.updateMethod(_selectedMethod!);

                              context.push('/patient/addMedication/details');
                            }
                          : null,
                    ),
                  ],
                ),
              ),
            )
          )
        );
      
  }
  
}
