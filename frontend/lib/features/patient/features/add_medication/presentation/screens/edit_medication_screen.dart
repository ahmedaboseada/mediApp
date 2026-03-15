import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/reminder_time_input_row.dart';
import 'package:medi/features/shared/auth/data/repo/auth_repo_impl.dart';
import 'package:medi/features/shared/auth/presentation/cubit/user_profile/user_profile_cubit.dart';
import 'package:medi/features/shared/auth/presentation/cubit/user_profile/user_profile_state.dart';

class EditMedicationScreen extends StatefulWidget {
  const EditMedicationScreen({super.key});

  @override
  State<EditMedicationScreen> createState() => _EditMedicationScreenState();
}

class _EditMedicationScreenState extends State<EditMedicationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();

  String? _selectedType;
  String? _selectedFrequency;

  final List<String> _types = <String>[
    'Pill',
    'Tablet',
    'Capsule',
    'Syrup',
    'Injection',
    'Drop',
    'Cream',
    'Ointment',
    'Inhaler',
  ];

  final List<String> _frequencyOptions = <String>[
    'Once daily',
    'Twice daily',
    'Every day',
    'Every 2 days',
    'Every 3 days',
    'Every week',
    'Every 2 weeks',
    'Every month',
    'As needed',
  ];

  final List<String> _reminders = <String>[];

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _timeController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserProfileCubit>(
      create: (_) => UserProfileCubit(getIt<AuthRepoImpl>()),
      child: BlocListener<UserProfileCubit, UserProfileState>(
        listener: (BuildContext context, UserProfileState state) {
          if (state is UserProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
            context.pop();
          } else if (state is UserProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          appBar: const CustomAppBar(title: 'Modify your medication'),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                AppSizes.w16,
                AppSizes.h12,
                AppSizes.w16,
                AppSizes.h24,
              ),
              child: Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: EdgeInsets.all(AppSizes.w16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        CustomTextField(
                          label: 'Medication Name',
                          controller: _nameController,
                          validator: (String? value) =>
                              value.validateRequiredField(),
                        ),
                        SizedBox(height: AppSizes.h16),
                        CustomDropdown(
                          label: 'Type',
                          hint: 'Select type',
                          items: _types,
                          value: _selectedType,
                          onChanged: (String value) {
                            setState(() {
                              _selectedType = value;
                            });
                          },
                        ),
                        SizedBox(height: AppSizes.h16),
                        CustomTextField(
                          label: 'Dosage',
                          controller: _dosageController,
                          validator: (String? value) =>
                              value.validateRequiredField(),
                        ),
                        SizedBox(height: AppSizes.h16),
                        CustomDropdown(
                          label: 'Frequency*',
                          hint: 'Select frequency',
                          items: _frequencyOptions,
                          value: _selectedFrequency,
                          validator: (String? value) =>
                              value.validateRequiredField(),
                          onChanged: (String value) {
                            setState(() {
                              _selectedFrequency = value;
                            });
                          },
                        ),
                        SizedBox(height: AppSizes.h16),
                        Text(
                          'Set Reminders',
                          style: AppStyles.black16400.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: AppSizes.h12),
                        ReminderTimeInputRow(
                          timeController: _timeController,
                          onSelectTime: _selectTime,
                          onAddReminder: _addReminder,
                          reminders: _reminders,
                          onRemoveReminder: _removeReminder,
                        ),
                        SizedBox(height: AppSizes.h24),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: PrimaryButton(
                                text: AppStrings.cancel,
                                backgroundColor: AppColors.secondary,
                                textColor: AppColors.primary,
                                onPressed: () => context.pop(),
                              ),
                            ),
                            SizedBox(width: AppSizes.w16),
                            Expanded(
                              child: PrimaryButton(
                                text: AppStrings.save,
                                onPressed: () => _handleSave(context),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectTime() async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      _timeController.text = selectedTime.format(context);
    }
  }

  void _addReminder() {
    if (_timeController.text.trim().isEmpty) {
      return;
    }
    setState(() {
      _reminders.add(_timeController.text.trim());
      _timeController.clear();
    });
  }

  void _removeReminder(int index) {
    setState(() {
      _reminders.removeAt(index);
    });
  }

  void _handleSave(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
  }
}
