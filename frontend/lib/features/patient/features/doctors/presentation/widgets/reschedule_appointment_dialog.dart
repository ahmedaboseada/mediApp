import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/doctors/data/repo/doctors_repo.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/my_bookings_cubit.dart';
import 'package:medi/features/patient/features/doctors/presentation/widgets/doctor_availability_section.dart';
import 'package:medi/features/patient/features/doctors/presentation/widgets/doctor_profile_calendar.dart';

class RescheduleAppointmentDialog extends StatefulWidget {
  const RescheduleAppointmentDialog({
    super.key,
    required this.doctorName,
    required this.doctorId,
    required this.cubit,
    required this.onReschedule,
  });

  final String doctorName;
  final String doctorId;
  final MyBookingsCubit cubit;
  final void Function(DateTime date, String time) onReschedule;

  @override
  State<RescheduleAppointmentDialog> createState() =>
      _RescheduleAppointmentDialogState();
}

class _RescheduleAppointmentDialogState
    extends State<RescheduleAppointmentDialog> {
  late final ValueNotifier<DateTime?> _selectedDate;
  late final ValueNotifier<String?> _selectedTimeSlot;
  List<String> _availableSlots = [];
  bool _isLoadingSlots = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = ValueNotifier<DateTime?>(DateTime.now());
    _selectedTimeSlot = ValueNotifier<String?>(null);
    _selectedDate.addListener(_onDateChanged);
    _fetchSlots(DateTime.now());
  }

  void _onDateChanged() {
    if (_selectedDate.value != null) {
      _fetchSlots(_selectedDate.value!);
    }
  }

  Future<void> _fetchSlots(DateTime date) async {
    setState(() {
      _isLoadingSlots = true;
      _availableSlots = [];
      _selectedTimeSlot.value = null;
    });

    final dateStr = date.toIso8601String().split('T')[0];
    final result = await getIt<DoctorsRepository>().getDoctorSlots(
      widget.doctorId,
      dateStr,
    );

    if (mounted) {
      result.fold(
        (failure) {
          setState(() {
            _isLoadingSlots = false;
          });
        },
        (slots) {
          setState(() {
            _availableSlots = slots;
            _isLoadingSlots = false;
          });
        },
      );
    }
  }

  @override
  void dispose() {
    _selectedDate.removeListener(_onDateChanged);
    _selectedDate.dispose();
    _selectedTimeSlot.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: AppSizes.w14),
      backgroundColor: AppColors.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r40),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.w14),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  // Container(
                  //   width: AppSizes.w48,
                  //   height: AppSizes.h48,
                  //   decoration: BoxDecoration(
                  //     color: AppColors.background,
                  //     borderRadius: BorderRadius.circular(AppSizes.r24),
                  //   ),
                  //   child: Icon(
                  //     Icons.person_outline,
                  //     color: AppColors.secondaryText,
                  //     size: AppSizes.w24,
                  //   ),
                  // ),
                  // SizedBox(width: AppSizes.w10),
                  Expanded(
                    child: Text(
                      widget.doctorName,
                      style: AppStyles.black24700.copyWith(
                        fontSize: AppSizes.sp32,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.h12),
              DoctorProfileCalendar(selectedDate: _selectedDate),
              if (_isLoadingSlots)
                const Center(child: CircularProgressIndicator())
              else if (_availableSlots.isEmpty)
                Center(
                  child: Text(
                    'No available slots for this date',
                    style: AppStyles.secondary12400,
                  ),
                )
              else
                DoctorAvailabilitySection(
                  timeSlots: _availableSlots,
                  selectedTimeSlot: _selectedTimeSlot,
                  onTimeSlotSelected: (timeSlot) {
                    _selectedTimeSlot.value = timeSlot;
                  },
                ),
              SizedBox(height: AppSizes.h20),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  onPressed: () {
                    if (_selectedDate.value != null &&
                        _selectedTimeSlot.value != null) {
                      Navigator.of(context).pop();
                      widget.onReschedule(
                        _selectedDate.value!,
                        _selectedTimeSlot.value!,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a date and time slot'),
                        ),
                      );
                    }
                  },
                  child: Text('Reschedule', style: AppStyles.white16600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
