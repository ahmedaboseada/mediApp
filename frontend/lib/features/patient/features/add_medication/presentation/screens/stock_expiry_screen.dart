import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medication_data_cubit.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medication_data_state.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/current_stock_field.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/custom_stepper.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/navigation_buttons.dart';

class StockExpiryScreen extends StatefulWidget {
  const StockExpiryScreen({super.key});

  @override
  State<StockExpiryScreen> createState() => _StockExpiryScreenState();
}

class _StockExpiryScreenState extends State<StockExpiryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentStockController = TextEditingController();
  final _expiryDateController = TextEditingController();

  bool _isCriticalModeEnabled = false;

  @override
  void dispose() {
    _currentStockController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      context.read<MedicationDataCubit>().updateStockAndExpiry(
        stock: int.tryParse(_currentStockController.text) ?? 0,
        expiryDate: _expiryDateController.text,
        isCriticalMode: _isCriticalModeEnabled,
      );
      context.push('/medicine/confirmation');
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
                      CustomStepper(currentStep: 4, title: 'Stock & Expiry'),
                      SizedBox(height: AppSizes.h32),

                      // Current Stock Field with Spinner
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Current stock', style: AppStyles.black14500),
                          SizedBox(height: AppSizes.h6),
                          CurrentStockField(
                            controller: _currentStockController,
                            onIncrement: () {
                              final currentValue =
                                  int.tryParse(_currentStockController.text) ??
                                  0;
                              setState(() {
                                _currentStockController.text =
                                    (currentValue + 1).toString();
                              });
                            },
                            onDecrement: () {
                              final currentValue =
                                  int.tryParse(_currentStockController.text) ??
                                  0;
                              if (currentValue > 0) {
                                setState(() {
                                  _currentStockController.text =
                                      (currentValue - 1).toString();
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.h16),

                      SizedBox(height: AppSizes.h32),

                      // Critical Mode Toggle Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Critical mode',
                                  style: AppStyles.black16400.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: AppSizes.h8),
                                Text(
                                  'When enabled, you\'ll receive a full-screen urgent alert to make sure this medication is never missed.',
                                  style: AppStyles.secondary12400,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: AppSizes.w16),
                          CustomToggleSwitch(
                            value: _isCriticalModeEnabled,
                            onChanged: (value) {
                              setState(() {
                                _isCriticalModeEnabled = value;
                              });
                            },
                            activeColor: AppColors.accent,
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.h32),

                      // Alert Box (Allergy & drug interaction check)
                      Container(
                        padding: EdgeInsets.all(AppSizes.w12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSizes.r10),
                          color: AppColors.primary.withOpacity(0.08),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_rounded,
                              color: AppColors.primary,
                              size: AppSizes.w20,
                            ),
                            SizedBox(width: AppSizes.w12),
                            Expanded(
                              child: Text(
                                'Allergy & drug interaction check will be performed automatically',
                                style: AppStyles.black14500.copyWith(
                                  color: AppColors.primary,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSizes.h32),

                      // Back and Next Buttons
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
