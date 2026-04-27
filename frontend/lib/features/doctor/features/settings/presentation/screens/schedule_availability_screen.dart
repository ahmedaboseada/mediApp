import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/constants/constants.dart';
import 'package:medi/features/doctor/features/complete_profile/data/repo/doctor_complete_profile_repo.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/controller/schedule_appointments/schedule_appointments_cubit.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/controller/schedule_appointments/schedule_appointments_state.dart';
import 'package:medi/features/doctor/features/settings/presentation/widgets/working_days_widget.dart';
import 'package:medi/features/shared/auth/data/models/doctor_model.dart';
import 'package:medi/features/shared/auth/data/repo/auth_repo.dart';

class ScheduleAvailabilityScreen extends StatefulWidget {
  const ScheduleAvailabilityScreen({super.key, required this.doctor});
  final DoctorModel doctor;
  @override
  State<ScheduleAvailabilityScreen> createState() =>
      _ScheduleAvailabilityScreenState();
}

class _ScheduleAvailabilityScreenState
    extends State<ScheduleAvailabilityScreen> {
  late TextEditingController _maxPatientsController;
  final _formKey = GlobalKey<FormState>();
  List<String> _formatWorkingDays(List<String> days) {
    final Map<String, String> dayMap = {
      'monday ': 'Mon',
      'tuesday': 'Tue',
      'wednesday': 'Wed',
      'thursday': 'Thu',
      'friday': 'Fri',
      'saturday': 'Sat',
      'sunday': 'Sun',
    };

    return days.map((day) => dayMap[day] ?? day.toLowerCase()).toList();
  }

  @override
  void initState() {
    super.initState();

    _maxPatientsController = TextEditingController(
      text: widget.doctor.maxDailyPatients.toString(),
    );
  }

  @override
  void dispose() {
    _maxPatientsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ScheduleAppointmentsCubit(getIt<DoctorCompleteProfileRepo>())
            ..loadDoctorSchedule(),
      child: BlocConsumer<ScheduleAppointmentsCubit, ScheduleAppointmentsState>(
        listener: (context, state) {
          if (state.isError && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Saved successfully'),
                backgroundColor: Colors.green,
              ),
            );

            context.pop();
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => context.pop(context),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(AppSizes.w16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: AppSizes.h24),
                            Text(
                              'Schedule & Availability',
                              style: AppStyles.black14500.copyWith(
                                fontSize: AppSizes.sp18,
                              ),
                            ),
                            SizedBox(height: AppSizes.h24),
                            Text(
                              'Working Days',
                              style: AppStyles.black14400.copyWith(
                                fontSize: AppSizes.sp16,
                              ),
                            ),
                            Text(
                              'Select the days you\'re available for appointments',
                              style: AppStyles.tertiary40012,
                            ),
                            SizedBox(height: AppSizes.h16),
                            WorkingDaysWidget(
                              initialDays: _formatWorkingDays(
                                // state.workingDays,
                                widget.doctor.workingDays,
                              ),
                              onDaysSelected: (days) {
                                context
                                    .read<ScheduleAppointmentsCubit>()
                                    .updateWorkingDays(days);
                              },
                            ),

                            SizedBox(height: AppSizes.h24),
                            QTextField(
                              initialSelectedValues:
                                  state.consultationDuration != null
                                  ? [
                                      widget.doctor.consultationDuration
                                          .toString(),
                                    ]
                                  : [],

                              singleSelect: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select consultation duration';
                                }
                                return null;
                              },
                              label: 'How long is each consultation?',
                              hint: 'Select Time',
                              items: DoctorConstants().consultationDurations,
                              onSelectionChange: (value) {
                                context
                                    .read<ScheduleAppointmentsCubit>()
                                    .updateConsultationDuration(
                                      value.isNotEmpty ? value.first : '',
                                    );
                              },
                            ),

                            SizedBox(height: AppSizes.h16),
                            TimePickerField(
                              label: 'Start Time',
                              initialTime:
                                  widget.doctor.workingHours.first.startHour !=
                                      null
                                  ? TimeOfDay(
                                      hour: int.parse(
                                        widget
                                            .doctor
                                            .workingHours
                                            .first
                                            .startHour!
                                            .split(':')
                                            .first,
                                      ),
                                      minute: int.parse(
                                        widget
                                            .doctor
                                            .workingHours
                                            .first
                                            .startHour!
                                            .split(':')
                                            .last,
                                      ),
                                    )
                                  : null,
                              onTimeSelected: (time) {
                                context
                                    .read<ScheduleAppointmentsCubit>()
                                    .updateStartTime(time);
                              },
                            ),

                            SizedBox(height: AppSizes.h16),
                            TimePickerField(
                              label: 'End Time',
                              initialTime:
                                  widget.doctor.workingHours.first.endHour !=
                                      null
                                  ? TimeOfDay(
                                      hour: int.parse(
                                        widget
                                            .doctor
                                            .workingHours
                                            .first
                                            .endHour!
                                            .split(':')
                                            .first,
                                      ),
                                      minute: int.parse(
                                        widget
                                            .doctor
                                            .workingHours
                                            .first
                                            .endHour!
                                            .split(':')
                                            .last,
                                      ),
                                    )
                                  : null,
                              onTimeSelected: (time) {
                                context
                                    .read<ScheduleAppointmentsCubit>()
                                    .updateEndTime(time);
                              },
                            ),

                            SizedBox(height: AppSizes.h16),
                            QTextField(
                              initialSelectedValues:
                                  widget.doctor.appointmentTypes,
                              validator: (types) {
                                if (types == null || types.isEmpty) {
                                  return 'Please select appointment types';
                                }
                                return null;
                              },
                              onSelectionChange: (types) {
                                context
                                    .read<ScheduleAppointmentsCubit>()
                                    .updateAppointmentTypes(types);
                              },
                              items: DoctorConstants().appointmentsTypes,
                              label: 'What type of appointments do you offer?',
                            ),

                            SizedBox(height: AppSizes.h16),
                            CustomTextField(
                              controller: _maxPatientsController,
                              hintText: 'Max patients per day',
                              keyboardType: TextInputType.number,
                              label: 'Max patients per day',
                            ),
                            SizedBox(height: AppSizes.h24),
                            PrimaryButton(
                              onPressed: state.isLoading
                                  ? null
                                  : () {
                                      final cubit = context
                                          .read<ScheduleAppointmentsCubit>();

                                      cubit.updateMaxDailyPatients(
                                        _maxPatientsController.text,
                                      );

                                      cubit.submitScheduleAndAppointments();
                                    },
                              text: state.isLoading ? 'Saving...' : 'Save',
                            ),
                            // PrimaryButton(
                            //   onPressed: state.isSubmitting
                            //       ? null
                            //       : () {
                            //           if (_formKey.currentState!.validate()) {
                            //             if (_maxPatientsController
                            //                 .text
                            //                 .isNotEmpty) {
                            //               context
                            //                   .read<ScheduleAppointmentsCubit>()
                            //                   .updateMaxDailyPatients(
                            //                     _maxPatientsController.text,
                            //                   );
                            //             }
                            //             context
                            //                 .read<ScheduleAppointmentsCubit>()
                            //                 .submitScheduleAndAppointments();
                            //           }
                            //         },
                            //   text: 'Save',
                            //   child: state.isSubmitting
                            //       ? const SizedBox(
                            //           height: 20,
                            //           width: 20,
                            //           child: CircularProgressIndicator(
                            //             strokeWidth: 2,
                            //             color: Colors.white,
                            //           ),
                            //         )
                            //       : null,
                            // ),
                            SizedBox(height: AppSizes.h24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
