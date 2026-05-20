import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/data/sync/sync_service.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';
import 'package:medi/features/patient/features/add_medication/data/repo/medicine_repo.dart';

class _SpecificDateReminders {
  _SpecificDateReminders({required this.date, required List<String> times})
    : times = times;

  final String date;
  final List<String> times;
}

class _WeeklyDayReminders {
  _WeeklyDayReminders({required this.day, required List<String> times})
    : times = times;

  final String day;
  final List<String> times;
}

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
  final TextEditingController _specificDateController = TextEditingController();

  String? _selectedType;
  String? _selectedFrequency;
  String? _selectedWeekDay;

  final List<String> _types = <String>[
    'tablet',
    'capsule',
    'syrup',
    'injection',
    'drop',
    'cream',
    'ointment',
    'inhaler',
  ];

  final List<String> _frequencyOptions = <String>[
    'daily',
    'weekly',
    'specific',
    'as needed',
  ];

  final List<String> _weekDays = <String>[
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  final List<String> _reminders = <String>[];
  final List<_WeeklyDayReminders> _weeklyReminders = <_WeeklyDayReminders>[];
  final List<_SpecificDateReminders> _specificReminders =
      <_SpecificDateReminders>[];

  bool get _isWeeklySelected => _selectedFrequency == 'weekly';
  bool get _isSpecificSelected => _selectedFrequency == 'specific';
  bool get _isAsNeededSelected => _selectedFrequency == 'as needed';
  bool get _requiresReminderInput => !_isAsNeededSelected;

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
    _specificDateController.dispose();
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
                          _reminders.clear();
                          _weeklyReminders.clear();
                          _specificReminders.clear();
                          _timeController.clear();
                          _selectedWeekDay = null;
                          _specificDateController.clear();
                        });
                      },
                    ),
                    if (_isWeeklySelected) ...[
                      SizedBox(height: AppSizes.h16),
                      CustomDropdown(
                        label: 'Select Day',
                        hint: 'Choose day',
                        items: _weekDays,
                        value: _selectedWeekDay,
                        validator: (String? value) =>
                            value.validateRequiredField(),
                        onChanged: (String value) {
                          setState(() {
                            _selectedWeekDay = value;
                          });
                        },
                      ),
                    ],
                    if (_requiresReminderInput) ...[
                      SizedBox(height: AppSizes.h16),
                      Text(
                        'Set Reminders',
                        style: AppStyles.black16400.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: AppSizes.h12),
                      if (_isSpecificSelected) ...[
                        CustomTextField(
                          label: 'Select Date',
                          hintText: 'yyyy-mm-dd',
                          controller: _specificDateController,
                          readOnly: true,
                          onTap: () => _selectSpecificDate(),
                          suffixIcon: Icon(
                            Icons.calendar_today,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: AppSizes.h12),
                      ],
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
                      if (_isSpecificSelected)
                        _buildSpecificReminderList()
                      else if (_isWeeklySelected)
                        _buildWeeklyReminderList()
                      else
                        _buildDefaultReminderList(),
                    ],
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

  Future<void> _selectSpecificDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (selectedDate != null) {
      _specificDateController.text = _formatIsoDate(selectedDate);
    }
  }

  String _formatIsoDate(DateTime dateTime) {
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    return '${dateTime.year}-$month-$day';
  }

  List<Map<String, dynamic>> _buildWeeklyPayload() {
    return _weeklyReminders
        .map(
          (entry) => <String, dynamic>{
            'day': entry.day.toLowerCase(),
            'times': List<String>.from(entry.times),
          },
        )
        .toList();
  }

  List<Map<String, dynamic>> _buildSpecificPayload() {
    return _specificReminders
        .map(
          (entry) => <String, dynamic>{
            'day': entry.date,
            'times': List<String>.from(entry.times),
          },
        )
        .toList();
  }

  void _addReminder() {
    final time = _timeController.text.trim();
    if (time.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a time'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_isSpecificSelected) {
      final specificDate = _specificDateController.text.trim();
      if (specificDate.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a date for specific schedule'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        final index = _specificReminders.indexWhere(
          (entry) => entry.date == specificDate,
        );

        if (index == -1) {
          _specificReminders.add(
            _SpecificDateReminders(date: specificDate, times: [time]),
          );
        } else if (!_specificReminders[index].times.contains(time)) {
          _specificReminders[index].times.add(time);
        }

        _timeController.clear();
      });
      return;
    }

    if (_isWeeklySelected) {
      final selectedDay = _selectedWeekDay;
      if (selectedDay == null || selectedDay.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a day for weekly schedule'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        final index = _weeklyReminders.indexWhere(
          (entry) => entry.day.toLowerCase() == selectedDay.toLowerCase(),
        );

        if (index == -1) {
          _weeklyReminders.add(
            _WeeklyDayReminders(day: selectedDay, times: [time]),
          );
        } else if (!_weeklyReminders[index].times.contains(time)) {
          _weeklyReminders[index].times.add(time);
        }

        _timeController.clear();
      });
      return;
    }

    setState(() {
      if (!_reminders.contains(time)) {
        _reminders.add(time);
      }
      _timeController.clear();
    });
  }

  void _removeReminder(int index) {
    setState(() {
      _reminders.removeAt(index);
    });
  }

  void _removeSpecificReminder({
    required int dateIndex,
    required int timeIndex,
  }) {
    setState(() {
      final times = _specificReminders[dateIndex].times;
      times.removeAt(timeIndex);
      if (times.isEmpty) {
        _specificReminders.removeAt(dateIndex);
      }
    });
  }

  void _removeWeeklyReminder({required int dayIndex, required int timeIndex}) {
    setState(() {
      final times = _weeklyReminders[dayIndex].times;
      times.removeAt(timeIndex);
      if (times.isEmpty) {
        _weeklyReminders.removeAt(dayIndex);
      }
    });
  }

  Widget _buildDefaultReminderList() {
    if (_reminders.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(
        _reminders.length,
        (index) => Padding(
          padding: EdgeInsets.only(top: AppSizes.h12, bottom: AppSizes.h8),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.w12,
              vertical: AppSizes.h12,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.r10),
              border: Border.all(color: AppColors.borderColor),
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
                Text(_reminders[index], style: AppStyles.black14500),
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
    );
  }

  Widget _buildSpecificReminderList() {
    if (_specificReminders.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(top: AppSizes.h12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(_specificReminders.length, (dateIndex) {
          final dateEntry = _specificReminders[dateIndex];
          return Padding(
            padding: EdgeInsets.only(bottom: AppSizes.h12),
            child: Container(
              padding: EdgeInsets.all(AppSizes.w12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.r10),
                border: Border.all(color: AppColors.borderColor),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateEntry.date,
                    style: AppStyles.black14500.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppSizes.h8),
                  ...List.generate(dateEntry.times.length, (timeIndex) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: AppSizes.h6),
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: AppColors.primary,
                            size: AppSizes.w18,
                          ),
                          SizedBox(width: AppSizes.w8),
                          Expanded(
                            child: Text(
                              dateEntry.times[timeIndex],
                              style: AppStyles.black14500,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _removeSpecificReminder(
                              dateIndex: dateIndex,
                              timeIndex: timeIndex,
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.red,
                              size: AppSizes.w20,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildWeeklyReminderList() {
    if (_weeklyReminders.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(top: AppSizes.h12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(_weeklyReminders.length, (dayIndex) {
          final dayEntry = _weeklyReminders[dayIndex];
          return Padding(
            padding: EdgeInsets.only(bottom: AppSizes.h12),
            child: Container(
              padding: EdgeInsets.all(AppSizes.w12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.r10),
                border: Border.all(color: AppColors.borderColor),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dayEntry.day,
                    style: AppStyles.black14500.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppSizes.h8),
                  ...List.generate(dayEntry.times.length, (timeIndex) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: AppSizes.h6),
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: AppColors.primary,
                            size: AppSizes.w18,
                          ),
                          SizedBox(width: AppSizes.w8),
                          Expanded(
                            child: Text(
                              dayEntry.times[timeIndex],
                              style: AppStyles.black14500,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _removeWeeklyReminder(
                              dayIndex: dayIndex,
                              timeIndex: timeIndex,
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.red,
                              size: AppSizes.w20,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<void> _handleSave(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_isSpecificSelected && _specificReminders.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one date with reminders'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_isWeeklySelected && _weeklyReminders.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one day with reminders'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_isSpecificSelected &&
        !_isWeeklySelected &&
        _requiresReminderInput &&
        _reminders.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one reminder'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final flattenedWeeklyReminders = _weeklyReminders
        .expand((entry) => entry.times)
        .toSet()
        .toList();

    final updated = _originalMedication.copyWith(
      name: _nameController.text.trim(),
      type: (_selectedType ?? _originalMedication.type).trim(),
      dosage: _dosageController.text.trim(),
      frequency: (_selectedFrequency ?? _originalMedication.frequency).trim(),
      reminders: _isSpecificSelected
          ? []
          : _isWeeklySelected
          ? flattenedWeeklyReminders
          : List<String>.from(_reminders),
      medicationType: Medication.medicationTypeFromLabel(_selectedType),
      weeklySchedule: _isWeeklySelected ? _buildWeeklyPayload() : null,
      specificSchedule: _isSpecificSelected ? _buildSpecificPayload() : null,
    );

    if (getIt<CaregiverModeCubit>().isManagingPatient) {
      final result = await getIt<MedicineRepo>().updateMedicineFromMedication(
        medicationId: _originalMedication.id,
        medication: updated,
      );

      if (result.isLeft()) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result.fold((failure) => failure.message, (_) => ''),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } else {
      // 🔥 Offline-sync (Optimistic)
      await SyncService.addToQueue(
        type: 'update',
        entity: 'medication',
        data: updated.toJson(),
      );

      await HiveService.updateMedication(
        original: _originalMedication,
        updated: updated,
      );
      await LocalNotificationService().rescheduleMedicationReminders(
        previousMedication: _originalMedication,
        updatedMedication: updated,
      );
    }
    if (!context.mounted) return;
    context.pop(updated);
  }
}
