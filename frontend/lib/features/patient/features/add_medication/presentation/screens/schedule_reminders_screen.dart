import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medication_data_cubit.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medication_data_state.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/custom_stepper.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/navigation_buttons.dart';

class ScheduleRemindersScreen extends StatefulWidget {
  const ScheduleRemindersScreen({super.key});

  @override
  State<ScheduleRemindersScreen> createState() =>
      _ScheduleRemindersScreenState();
}

class _ScheduleRemindersScreenState extends State<ScheduleRemindersScreen> {
  final _formKey = GlobalKey<FormState>();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _timeController = TextEditingController();

  String? _selectedFrequency;
  final List<String> _reminders = [];

  final List<String> _frequencyOptions = [
    'Every day',
    'Every 2 days',
    'Every 3 days',
    'Every week',
    'Every 2 weeks',
    'Every month',
    'As needed',
  ];

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (selectedDate != null) {
      controller.text =
          '${selectedDate.month}/${selectedDate.day}/${selectedDate.year}';
    }
  }

  Future<void> _selectTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      _timeController.text = selectedTime.format(context);
    }
  }

  void _addReminder() {
    if (_timeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a time'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _reminders.add(_timeController.text);
      _timeController.clear();
    });
  }

  void _removeReminder(int index) {
    setState(() {
      _reminders.removeAt(index);
    });
  }

  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      if (_selectedFrequency == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select frequency'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      context.read<MedicationDataCubit>().updateSchedule(
        frequency: _selectedFrequency!,
        startDate: _startDateController.text,
        endDate: _endDateController.text,
        reminders: _reminders,
      );

      context.push('/medicine/stock');
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
                        currentStep: 3,
                        title: 'Schedule & Reminders',
                      ),
                      SizedBox(height: AppSizes.h32),

                      // Frequency Dropdown
                      CustomDropdown(
                        label: 'Frequency',
                        hint: 'Select frequency',
                        items: _frequencyOptions,
                        onChanged: (value) {
                          setState(() {
                            _selectedFrequency = value;
                          });
                        },
                      ),
                      SizedBox(height: AppSizes.h16),

                      // Start Date
                      CustomTextField(
                        label: 'Start date',
                        hintText: 'mm/dd/yyyy',
                        controller: _startDateController,
                        readOnly: true,
                        onTap: () => _selectDate(_startDateController),
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: AppColors.primary,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please select start date';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSizes.h16),

                      // End Date
                      CustomTextField(
                        label: 'End date',
                        hintText: 'mm/dd/yyyy',
                        controller: _endDateController,
                        readOnly: true,
                        onTap: () => _selectDate(_endDateController),
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: AppColors.primary,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please select end date';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSizes.h32),

                      // Set Reminders Section
                      Text(
                        'Set Reminders',
                        style: AppStyles.black16400.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: AppSizes.h16),

                      // Time Input Row
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: 'Time',
                              hintText: '00:00',
                              controller: _timeController,
                              readOnly: true,
                              onTap: _selectTime,
                              suffixIcon: Icon(
                                Icons.access_time,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          SizedBox(width: AppSizes.w12),
                          Padding(
                            padding: EdgeInsets.only(top: AppSizes.h20),
                            child: GestureDetector(
                              onTap: _addReminder,
                              child: Container(
                                width: AppSizes.w48,
                                height: AppSizes.h48,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.r10,
                                  ),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: AppSizes.w24,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.h16),

                      // Reminders List
                      if (_reminders.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: List.generate(
                            _reminders.length,
                            (index) => Padding(
                              padding: EdgeInsets.only(bottom: AppSizes.h8),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSizes.w12,
                                  vertical: AppSizes.h12,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.r10,
                                  ),
                                  border: Border.all(
                                    color: AppColors.borderColor,
                                  ),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      color: AppColors.primary,
                                      size: AppSizes.w20,
                                    ),
                                    SizedBox(width: AppSizes.w12),
                                    Text(
                                      _reminders[index],
                                      style: AppStyles.black14500,
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () => _removeReminder(index),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.red,
                                        size: AppSizes.w20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
