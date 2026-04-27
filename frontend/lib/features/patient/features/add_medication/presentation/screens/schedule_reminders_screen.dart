import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medication_data_cubit.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/custom_stepper.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/navigation_buttons.dart';

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
  final _specificDateController = TextEditingController();

  String? _selectedFrequency;
  String? _selectedWeekDay;

  final List<String> _reminders = [];
  final List<_WeeklyDayReminders> _weeklyReminders = [];
  final List<_SpecificDateReminders> _specificReminders = [];

  final List<String> _frequencyOptions = [
    'daily',
    'weekly',
    'specific',
    'as needed',
  ];

  final List<String> _weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  bool get _isWeeklySelected => _selectedFrequency == 'weekly';

  bool get _isSpecificSelected => _selectedFrequency == 'specific';

  bool get _isAsNeededSelected => _selectedFrequency == 'as needed';

  bool get _requiresReminderInput =>
      _selectedFrequency == 'daily' ||
      _selectedFrequency == 'weekly' ||
      _selectedFrequency == 'specific';

  @override
  void dispose() {
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
      _timeController.text = selectedTime.format(context);
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
            _WeeklyDayReminders(day: selectedDay, times: [time]),
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
            _SpecificDateReminders(date: specificDate, times: [time]),
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
    return _weeklyReminders.expand((entry) => entry.times).toSet().toList();
  }

  List<String> _flattenSpecificTimes() {
    return _specificReminders.expand((entry) => entry.times).toSet().toList();
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

  void _handleNext() {
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

    if (_requiresReminderInput) {
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

    context.read<MedicationDataCubit>().updateSchedule(
      frequency: _selectedFrequency!,
      startDate: _isSpecificSelected ? '' : _startDateController.text,
      endDate: _isSpecificSelected ? '' : _endDateController.text,
      reminders: _isWeeklySelected
          ? _flattenWeeklyTimes()
          : _isSpecificSelected
          ? _flattenSpecificTimes()
          : _reminders,
      weeklySchedule: _isWeeklySelected
          ? _buildWeeklyPayload()
          : const <Map<String, dynamic>>[],
      specificSchedule: _isSpecificSelected
          ? _buildSpecificPayload()
          : const <Map<String, dynamic>>[],
    );

    context.push('/medicine/stock');
  }

  Widget _buildTimeInputRow() {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            label: 'Time',
            hintText: '00:00',
            controller: _timeController,
            readOnly: true,
            onTap: _selectTime,
            suffixIcon: Icon(Icons.access_time, color: AppColors.primary),
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
                borderRadius: BorderRadius.circular(AppSizes.r10),
              ),
              child: Icon(Icons.add, color: Colors.white, size: AppSizes.w24),
            ),
          ),
        ),
      ],
    );
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
          padding: EdgeInsets.only(bottom: AppSizes.h8),
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

  Widget _buildWeeklyReminderList() {
    if (_weeklyReminders.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
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
    );
  }

  Widget _buildSpecificReminderList() {
    if (_specificReminders.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.primaryText),
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
                  CustomStepper(currentStep: 3, title: 'Schedule & Reminders'),
                  SizedBox(height: AppSizes.h32),

                  CustomDropdown(
                    label: 'Frequency',
                    hint: 'Select frequency',
                    items: _frequencyOptions,
                    value: _selectedFrequency,
                    onChanged: (value) {
                      setState(() {
                        _selectedFrequency = value;
                        _clearScheduleInputs();
                      });
                    },
                  ),
                  SizedBox(height: AppSizes.h16),

                  if (!_isSpecificSelected) ...[
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
                    SizedBox(height: AppSizes.h32),
                  ] else
                    SizedBox(height: AppSizes.h16),

                  Text(
                    'Set Reminders',
                    style: AppStyles.black16400.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppSizes.h16),

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
                    _buildTimeInputRow(),
                    SizedBox(height: AppSizes.h16),
                    if (_isWeeklySelected)
                      _buildWeeklyReminderList()
                    else if (_isSpecificSelected)
                      _buildSpecificReminderList()
                    else
                      _buildDefaultReminderList(),
                  ],

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
  }

  String _formatIsoDate(DateTime dateTime) {
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    return '${dateTime.year}-$month-$day';
  }
}
