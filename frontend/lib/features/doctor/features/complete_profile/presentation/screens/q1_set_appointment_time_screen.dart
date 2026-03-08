import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/complete_profile/data/repo/doctor_complete_profile_repo.dart';
import 'package:medi/features/doctor/features/complete_profile/constants/constants.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/controller/q_flow/q_flow_cubit.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/widgets/q_progress_widget.dart';

class Q1SetAppointmentTimeScreen extends StatefulWidget {
  const Q1SetAppointmentTimeScreen({super.key});

  @override
  State<Q1SetAppointmentTimeScreen> createState() =>
      _Q1SetAppointmentTimeScreenState();
}

class _Q1SetAppointmentTimeScreenState
    extends State<Q1SetAppointmentTimeScreen> {
  List<String> _workingDays = [];
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _consultationDuration;
  bool _isLoading = false;

  String _format24h(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  int _parseDurationMinutes(String duration) {
    final value = duration.split(' ').first;
    return int.tryParse(value) ?? 30;
  }

  Future<void> _submitSchedule() async {
    if (_workingDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one working day')),
      );
      return;
    }

    if (_startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select start and end time')),
      );
      return;
    }

    if (_consultationDuration == null || _consultationDuration!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select consultation duration')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final repo = getIt<DoctorCompleteProfileRepo>();
    final result = await repo.completeSchedule(
      workingDays: _workingDays.map((day) => day.toLowerCase()).toList(),
      startHour: _format24h(_startTime!),
      endHour: _format24h(_endTime!),
      consultationDuration: _parseDurationMinutes(_consultationDuration!),
    );

    if (!mounted) {
      return;
    }

    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failure.message)));
      },
      (_) {
        setState(() {
          _isLoading = false;
        });
        context.read<QFlowCubit>().next();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.w16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: AppSizes.h16),
                Text(
                  AppStrings.appointmentAvailabilityTitle,
                  style: AppStyles.primary70024.copyWith(
                    fontSize: AppSizes.sp22,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSizes.h8),
                Text(
                  AppStrings.appointmentAvailabilitySubtitle,
                  style: AppStyles.tertiary14400,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSizes.h24),
                Image.asset(AppAssets.addInfo, height: AppSizes.h270),
                SizedBox(height: AppSizes.h24),
                QTextField(
                  search: false,
                  label: AppStrings.workingDaysQuestion,
                  items: CompleteProfileConstants().workingDays,
                  onSelectionChange: (value) {
                    _workingDays = value;
                  },
                ),
                SizedBox(height: AppSizes.h16),
                TimePickerField(
                  label: 'Start Time',
                  onTimeSelected: (time) {
                    _startTime = time;
                  },
                ),
                SizedBox(height: AppSizes.h16),
                TimePickerField(
                  label: 'End Time',
                  onTimeSelected: (time) {
                    _endTime = time;
                  },
                ),
                SizedBox(height: AppSizes.h16),
                CustomDropdown(
                  label: AppStrings.consultationLengthLabel,
                  hint: AppStrings.selectTime,
                  items: AppStrings.consultationDurations,
                  onChanged: (value) {
                    _consultationDuration = value;
                  },
                ),
                SizedBox(height: AppSizes.h16),
                InfoNoteWidget(text: AppStrings.appointmentScheduleNote),
                SizedBox(height: AppSizes.h24),
                const QProgressWidget(step: 0),
                SizedBox(height: AppSizes.h12),
                PrimaryButton(
                  text: AppStrings.next,
                  onPressed: _isLoading ? null : _submitSchedule,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
                SizedBox(height: AppSizes.h24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
