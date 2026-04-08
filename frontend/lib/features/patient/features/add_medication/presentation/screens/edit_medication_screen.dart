import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';
import 'package:medi/features/patient/features/add_medication/data/repo/medicine_repo.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/reminder_time_input_row.dart';

class EditMedicationScreen extends StatefulWidget {
  const EditMedicationScreen({super.key, this.medication});

  final Medication? medication;

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

  late final Medication _originalMedication;

  @override
  void initState() {
    super.initState();
    _originalMedication = widget.medication ?? const Medication();
    _nameController.text = _originalMedication.name;
    _dosageController.text = _originalMedication.dosage;
    _selectedType = _originalMedication.type.isNotEmpty
        ? _originalMedication.type
        : null;
    _selectedFrequency = _originalMedication.frequency.isNotEmpty
        ? _originalMedication.frequency
        : null;
    _reminders.addAll(_originalMedication.reminders);
    _expiryDateController.text = _originalMedication.expiryDate;
  }

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
    return Scaffold(
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
                      validator: (String? value) =>
                          value.validateRequiredField(),
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

  Future<void> _handleSave(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final updated = _originalMedication.copyWith(
      name: _nameController.text.trim(),
      type: (_selectedType ?? _originalMedication.type).trim(),
      dosage: _dosageController.text.trim(),
      frequency: (_selectedFrequency ?? _originalMedication.frequency).trim(),
      reminders: List<String>.from(_reminders),
      medicationType: Medication.medicationTypeFromLabel(_selectedType),
    );

    final medicationId = _originalMedication.id.trim();
    if (medicationId.isNotEmpty) {
      final result = await getIt<MedicineRepo>().updateMedicineFromMedication(
        medicationId: medicationId,
        medication: updated,
      );
      if (result.isLeft()) {
        final error = result.swap().getOrElse(
          () => ServerFailure('Update failed'),
        );
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message), backgroundColor: Colors.red),
        );
        return;
      }
    }

    await HiveService.updateMedication(
      original: _originalMedication,
      updated: updated,
    );
    await LocalNotificationService().rescheduleMedicationReminders(
      previousMedication: _originalMedication,
      updatedMedication: updated,
    );
    if (!context.mounted) return;
    context.pop(updated);
  }
}
