import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/doctors/presentation/widgets/doctor_availability_section.dart';
import 'package:medi/features/patient/features/doctors/presentation/widgets/doctor_profile_calendar.dart';

class RescheduleAppointmentDialog extends StatefulWidget {
  const RescheduleAppointmentDialog({
    super.key,
    required this.doctorName,
    required this.onReschedule,
  });

  final String doctorName;
  final VoidCallback onReschedule;

  @override
  State<RescheduleAppointmentDialog> createState() =>
      _RescheduleAppointmentDialogState();
}

class _RescheduleAppointmentDialogState
    extends State<RescheduleAppointmentDialog> {
  static const List<String> _timeSlots = [
    '01:30 PM',
    '3:00 PM',
    '5:00 PM',
    '7:00 PM',
    '9:00 PM',
    '10:00 PM',
  ];

  late final ValueNotifier<DateTime?> _selectedDate;
  late final ValueNotifier<String?> _selectedTimeSlot;

  @override
  void initState() {
    super.initState();
    _selectedDate = ValueNotifier<DateTime?>(DateTime.now());
    _selectedTimeSlot = ValueNotifier<String?>('9:00 PM');
  }

  @override
  void dispose() {
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
                  Container(
                    width: AppSizes.w48,
                    height: AppSizes.h48,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(AppSizes.r24),
                    ),
                    child: Icon(
                      Icons.person_outline,
                      color: AppColors.secondaryText,
                      size: AppSizes.w24,
                    ),
                  ),
                  SizedBox(width: AppSizes.w10),
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
              SizedBox(height: AppSizes.h16),
              DoctorAvailabilitySection(
                timeSlots: _timeSlots,
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
                    Navigator.of(context).pop();
                    widget.onReschedule();
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
