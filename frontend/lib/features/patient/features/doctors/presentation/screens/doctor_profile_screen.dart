import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/doctors/data/models/doctor_summary.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/booking_cubit.dart';
import 'package:medi/features/patient/features/doctors/presentation/widgets/doctor_availability_section.dart';
import 'package:medi/features/patient/features/doctors/presentation/widgets/doctor_profile_calendar.dart';
import 'package:medi/features/patient/features/doctors/presentation/widgets/doctor_profile_header.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key, required this.doctor});

  final DoctorModel doctor;

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  late final ValueNotifier<DateTime?> _selectedDate;
  late final ValueNotifier<String?> _selectedTimeSlot;

  @override
  void initState() {
    super.initState();
    final bookingCubit = context.read<BookingCubit>();
    final profileDoctor = widget.doctor;
    bookingCubit.setDoctor(profileDoctor);

    _selectedDate = ValueNotifier<DateTime?>(bookingCubit.state.selectedDate);
    _selectedTimeSlot = ValueNotifier<String?>(
      bookingCubit.state.selectedTimeSlot,
    );
    _selectedDate.addListener(() {
      final value = _selectedDate.value;
      if (value != null) {
        bookingCubit.updateSelectedDate(value);
      }
    });
  }

  @override
  void dispose() {
    _selectedDate.dispose();
    _selectedTimeSlot.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        final DoctorModel profileDoctor = state.appointmentReviewData.doctor!;

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                DoctorProfileHeader(
                  doctor: profileDoctor,
                  onBack: () => context.pop(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      AppSizes.w16,
                      AppSizes.h16,
                      AppSizes.w16,
                      AppSizes.h16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DoctorProfileCalendar(selectedDate: _selectedDate),
                        SizedBox(height: AppSizes.h24),
                        state.isLoadingSlots
                            ? const Center(child: CircularProgressIndicator())
                            : DoctorAvailabilitySection(
                                timeSlots: state.availableSlots,
                                selectedTimeSlot: _selectedTimeSlot,
                                onTimeSlotSelected: (timeSlot) {
                                  _selectedTimeSlot.value = timeSlot;
                                  context
                                      .read<BookingCubit>()
                                      .updateSelectedTimeSlot(timeSlot);
                                },
                              ),
                        SizedBox(height: AppSizes.h24),
                        if (state.availableSlots.isNotEmpty) ...[
                          SizedBox(
                            width: double.infinity,
                            child: PrimaryButton(
                              text: 'Book Appointment',
                              onPressed: () => context.push(
                                '/doctors/profile/book',
                                extra: profileDoctor,
                              ),
                            ),
                          ),
                        ] else ...[
                          const Center(child: Text('No available slots')),
                        ],
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
