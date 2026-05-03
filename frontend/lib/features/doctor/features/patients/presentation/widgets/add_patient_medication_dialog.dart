import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/patients/presentation/cubit/manage_meds/mange_meds_cubit.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/reminder_grouped_list_view.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/reminder_simple_list_view.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/reminder_time_picker_row.dart';

class _WeeklyDayReminders {
  _WeeklyDayReminders({required this.day, required this.times});

  final String day;
  final List<String> times;
}

class _SpecificDateReminders {
  _SpecificDateReminders({required this.date, required this.times});

  final String date;
  final List<String> times;
}

class AddPatientMedicationDialog extends StatefulWidget {
  const AddPatientMedicationDialog({
    super.key,
    required this.patientName,
    required this.patientId,
  });

  final String patientName;
  final String patientId;

  @override
  State<AddPatientMedicationDialog> createState() =>
      _AddPatientMedicationDialogState();
}

class _AddPatientMedicationDialogState
    extends State<AddPatientMedicationDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _medicationNameController =
      TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
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

  @override
  void dispose() {
    _medicationNameController.dispose();
    _dosageController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _timeController.dispose();
    _specificDateController.dispose();
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

  Future<void> _selectTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      _timeController.text = _formatTimeOfDay(selectedTime);
    }
  }

  void _clearScheduleInputs() {
    _reminders.clear();
    _weeklyReminders.clear();
    _specificReminders.clear();
    _selectedWeekDay = null;
    _specificDateController.clear();
    _timeController.clear();
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
            _WeeklyDayReminders(day: selectedDay, times: <String>[time]),
          );
        } else if (!_weeklyReminders[index].times.contains(time)) {
          _weeklyReminders[index].times.add(time);
        }

        _timeController.clear();
      });
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
            _SpecificDateReminders(date: specificDate, times: <String>[time]),
          );
        } else if (!_specificReminders[index].times.contains(time)) {
          _specificReminders[index].times.add(time);
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

  void _removeWeeklyReminder({required int dayIndex, required int timeIndex}) {
    setState(() {
      final times = _weeklyReminders[dayIndex].times;
      times.removeAt(timeIndex);
      if (times.isEmpty) {
        _weeklyReminders.removeAt(dayIndex);
      }
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

  List<String> _flattenWeeklyTimes() {
    return _weeklyReminders
        .expand((entry) => entry.times)
        .map(_normalizeTimeString)
        .toSet()
        .toList();
  }

  List<String> _flattenSpecificTimes() {
    return _specificReminders
        .expand((entry) => entry.times)
        .map(_normalizeTimeString)
        .toSet()
        .toList();
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hour.toString().padLeft(2, '0');
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _normalizeTimeString(String value) {
    final trimmed = value.trim();
    final match = RegExp(r'^(\d{1,2}):(\d{2})\s*([AaPp][Mm])$').firstMatch(
      trimmed,
    );

    if (match == null) {
      return trimmed;
    }

    var hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    final period = match.group(3)!.toUpperCase();

    if (period == 'PM' && hour != 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  Future<void> _handleAdd() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedFrequency == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select frequency'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_isAsNeededSelected) {
      final hasValidReminders = _isWeeklySelected
          ? _weeklyReminders.isNotEmpty
          : _isSpecificSelected
          ? _specificReminders.isNotEmpty
          : _reminders.isNotEmpty;

      if (!hasValidReminders) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please add at least one reminder'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    final result = await context.read<ManageMedsCubit>().addMedication(
      patientId: widget.patientId,
      name: _medicationNameController.text.trim(),
      type: _selectedType!.trim(),
      dosage: _dosageController.text.trim(),
      frequency: _selectedFrequency!,
      daily: _isWeeklySelected
          ? _flattenWeeklyTimes()
          : _isSpecificSelected
          ? _flattenSpecificTimes()
          : _reminders,
    );

    if (!mounted) {
      return;
    }

    result.fold(
      (error) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(error.message),
              backgroundColor: Colors.red,
            ),
          );
      },
      (message) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(message)),
          );
        Navigator.of(context).pop();
      },
    );
  }

  String _formatIsoDate(DateTime dateTime) {
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    return '${dateTime.year}-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: AppSizes.w16,
        vertical: AppSizes.h24,
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(AppSizes.r24),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSizes.w20,
                AppSizes.h18,
                AppSizes.w20,
                AppSizes.h8,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add New Medication',
                          style: AppStyles.black24700.copyWith(
                            fontSize: AppSizes.sp22,
                          ),
                        ),
                        SizedBox(height: AppSizes.h6),
                        Text(
                          "Add a new medication to ${widget.patientName}'s treatment plan.",
                          style: AppStyles.secondary12400,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppSizes.w20,
                  AppSizes.h8,
                  AppSizes.w20,
                  AppSizes.h20,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomTextField(
                        label: 'Medication Name',
                        hintText: 'e.g, Aspirin',
                        controller: _medicationNameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter medication name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSizes.h16),
                      CustomDropdown(
                        label: 'Type',
                        hint: 'Select type',
                        items: _types,
                        value: _selectedType,
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value;
                          });
                        },
                        validator: (value) => value.validateRequiredField(),
                      ),
                      SizedBox(height: AppSizes.h16),
                      CustomTextField(
                        label: 'Dosage',
                        hintText: 'e.g, 100mg',
                        controller: _dosageController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter dosage';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSizes.h16),
                      CustomDropdown(
                        label: 'Frequency*',
                        hint: 'Select frequency',
                        items: _frequencyOptions,
                        value: _selectedFrequency,
                        onChanged: (value) {
                          setState(() {
                            _selectedFrequency = value;
                            _clearScheduleInputs();
                          });
                        },
                        validator: (value) => value.validateRequiredField(),
                      ),
                      if (!_isSpecificSelected) ...[
                        SizedBox(height: AppSizes.h16),
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
                      ],
                      SizedBox(height: AppSizes.h20),
                      Text(
                        'Set Reminders',
                        style: AppStyles.black16400.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: AppSizes.h12),
                      if (_isAsNeededSelected)
                        Text(
                          'As needed medications do not require fixed reminder times.',
                          style: AppStyles.secondary12400,
                        )
                      else ...[
                        if (_isWeeklySelected) ...[
                          CustomDropdown(
                            label: 'Day',
                            hint: 'Select day',
                            items: _weekDays,
                            value: _selectedWeekDay,
                            onChanged: (value) {
                              setState(() {
                                _selectedWeekDay = value;
                              });
                            },
                            validator: (value) => value.validateRequiredField(),
                          ),
                          SizedBox(height: AppSizes.h12),
                        ],
                        if (_isSpecificSelected) ...[
                          CustomTextField(
                            label: 'Specific date',
                            hintText: 'yyyy-mm-dd',
                            controller: _specificDateController,
                            readOnly: true,
                            onTap: _selectSpecificDate,
                            suffixIcon: Icon(
                              Icons.calendar_today,
                              color: AppColors.primary,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please select specific date';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: AppSizes.h12),
                        ],
                        ReminderTimePickerRow(
                          timeController: _timeController,
                          onSelectTime: _selectTime,
                          onAddReminder: _addReminder,
                        ),
                        SizedBox(height: AppSizes.h16),
                        if (_isWeeklySelected)
                          ReminderGroupedListView<_WeeklyDayReminders>(
                            items: _weeklyReminders,
                            titleBuilder: (item) => item.day,
                            timesBuilder: (item) => item.times,
                            onRemoveTime: (groupIndex, timeIndex) {
                              _removeWeeklyReminder(
                                dayIndex: groupIndex,
                                timeIndex: timeIndex,
                              );
                            },
                          )
                        else if (_isSpecificSelected)
                          ReminderGroupedListView<_SpecificDateReminders>(
                            items: _specificReminders,
                            titleBuilder: (item) => item.date,
                            timesBuilder: (item) => item.times,
                            onRemoveTime: (groupIndex, timeIndex) {
                              _removeSpecificReminder(
                                dateIndex: groupIndex,
                                timeIndex: timeIndex,
                              );
                            },
                          )
                        else
                          ReminderSimpleListView(
                            reminders: _reminders,
                            onRemoveReminder: _removeReminder,
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSizes.w20,
                0,
                AppSizes.w20,
                AppSizes.h20,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SecondryButton(
                      onPressed: () => Navigator.of(context).pop(),

                      text: 'Cancel',
                    ),
                  ),
                  SizedBox(width: AppSizes.w12),
                  Expanded(child: BlocBuilder<ManageMedsCubit, ManageMedsState>(
                    builder: (context, state) {
                      final isLoading = state.status == ManageMedsStatus.loading;
                      return PrimaryButton(
                        onPressed: isLoading ? null : _handleAdd,
                        text: isLoading ? 'Adding...' : 'Add',
                      );
                    },
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
