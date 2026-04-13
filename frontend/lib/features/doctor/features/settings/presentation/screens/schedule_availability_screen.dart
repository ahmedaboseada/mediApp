import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/constants/constants.dart';
import 'package:medi/features/doctor/features/complete_profile/data/repo/doctor_complete_profile_repo.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/controller/schedule_appointments/schedule_appointments_cubit.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/controller/schedule_appointments/schedule_appointments_state.dart';
import 'package:medi/features/doctor/features/settings/presentation/widgets/working_days_widget.dart';

class ScheduleAvailabilityScreen extends StatefulWidget {
  const ScheduleAvailabilityScreen({super.key});

  @override
  State<ScheduleAvailabilityScreen> createState() =>
      _ScheduleAvailabilityScreenState();
}

class _ScheduleAvailabilityScreenState
    extends State<ScheduleAvailabilityScreen> {
  late TextEditingController _maxPatientsController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _maxPatientsController = TextEditingController();
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
          ScheduleAppointmentsCubit(getIt<DoctorCompleteProfileRepo>()),
      child: BlocConsumer<ScheduleAppointmentsCubit, ScheduleAppointmentsState>(
        listener: (context, state) {
          if (state.errorMessage != null && !state.showFieldErrors) {
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
                content: Text('Schedule and appointments updated successfully'),
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
                              onDaysSelected: (days) {
                                context
                                    .read<ScheduleAppointmentsCubit>()
                                    .updateWorkingDays(days);
                              },
                            ),

                            SizedBox(height: AppSizes.h24),
                            CustomDropdown(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select consultation duration';
                                }
                                return null;
                              },
                              label: 'How long is each consultation?',
                              hint: 'Select Time',
                              items: ['15 min', '30 min', '45 min', '60 min'],
                              onChanged: (value) {
                                context
                                    .read<ScheduleAppointmentsCubit>()
                                    .updateConsultationDuration(value);
                              },
                            ),

                            SizedBox(height: AppSizes.h16),
                            TimePickerField(
                              label: 'Start Time',
                              onTimeSelected: (time) {
                                context
                                    .read<ScheduleAppointmentsCubit>()
                                    .updateStartTime(time);
                              },
                              validator: (time) {
                                if (time == null) {
                                  return 'Please select start time';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: AppSizes.h16),
                            TimePickerField(
                              label: 'End Time',
                              onTimeSelected: (time) {
                                context
                                    .read<ScheduleAppointmentsCubit>()
                                    .updateEndTime(time);
                              },
                              validator: (time) {
                                if (time == null) {
                                  return 'Please select end time';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: AppSizes.h16),
                            QTextField(
                              validator: (types) {
                                if (types == null || types.isEmpty) {
                                  return 'Please select appointment types';
                                }
                                return null;
                              },
                              onSelectionChange: (List<String> types) {
                                context
                                    .read<ScheduleAppointmentsCubit>()
                                    .updateAppointmentTypes(types);
                              },
                              items: DoctorConstants().appointmentsTypes,
                              label: 'What type of appointments do you offer?',
                            ),

                            SizedBox(height: AppSizes.h16),
                            CustomTextField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter max patients per day';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                              controller: _maxPatientsController,
                              hintText: 'Max patients per day',
                              keyboardType: TextInputType.number,
                              label: 'Max patients per day',
                            ),

                            SizedBox(height: AppSizes.h24),
                            PrimaryButton(
                              onPressed: state.isSubmitting
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        if (_maxPatientsController
                                            .text
                                            .isNotEmpty) {
                                          context
                                              .read<ScheduleAppointmentsCubit>()
                                              .updateMaxDailyPatients(
                                                _maxPatientsController.text,
                                              );
                                        }
                                        context
                                            .read<ScheduleAppointmentsCubit>()
                                            .submitScheduleAndAppointments();
                                      }
                                    },
                              text: 'Save',
                              child: state.isSubmitting
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
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
