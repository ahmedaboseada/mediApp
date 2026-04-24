import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/doctors/data/models/appointment_review_data.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/booking_cubit.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class PatientDetailsScreen extends StatelessWidget {
  const PatientDetailsScreen({super.key, this.initialData});

  final AppointmentReviewData? initialData;

  void _handleNext(BuildContext context, BookingState state) {
    context.push(
      AppRouter.patientPaymentMethodScreen,
      extra: state.appointmentReviewData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        return Scaffold(
          appBar: const CustomAppBar(title: 'Patient Details'),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.w16,
                      vertical: AppSizes.h12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        QTextField(
                          singleSelect: true,
                          onSelectionChange: (List<String> value) {
                            if (value.isEmpty) return;
                            context.read<BookingCubit>().updateBookingFor(
                              value.first,
                            );
                          },
                          items: [
                            DropdownItem(value: 'self', label: 'Self'),
                            DropdownItem(value: 'son', label: 'son'),
                            DropdownItem(value: 'daughter', label: 'Daughter'),
                            DropdownItem(value: 'father', label: 'Father'),
                            DropdownItem(value: 'mother', label: 'Mother'),
                          ],
                          label: 'Booking for',
                          hint: 'Self',
                          search: false,
                        ),
                        SizedBox(height: AppSizes.h18),
                        CustomTextField(
                          label: 'your Age',
                          hintText: 'Enter your age',
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            final age = int.tryParse(value);
                            if (age != null) {
                              context.read<BookingCubit>().updatePatientDetails(
                                age: age,
                              );
                            }
                          },
                        ),
                        SizedBox(height: AppSizes.h18),
                        GenderField(
                          value: state.appointmentReviewData.patientGender,
                          onGenderChanged: (value) {
                            context.read<BookingCubit>().updatePatientDetails(
                              gender: value,
                            );
                          },
                        ),
                        SizedBox(height: AppSizes.h18),
                        CustomTextField(
                          label: 'Write Your Problem',
                          hintText: 'Write here...',
                          maxLines: 7,
                          onChanged: (value) {
                            context.read<BookingCubit>().updatePatientDetails(
                              problem: value,
                            );
                          },
                        ),
                        SizedBox(height: AppSizes.h24),
                        PrimaryButton(
                          text: 'Next',
                          onPressed: () => _handleNext(context, state),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
