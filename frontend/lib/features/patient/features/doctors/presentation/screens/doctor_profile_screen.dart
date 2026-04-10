import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:horizontal_calender_mz/horizontal_calender_mz.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/doctors/data/models/doctor_summary.dart';
import 'package:medi/features/patient/features/doctors/presentation/widgets/doctor_availability_section.dart';
import 'package:medi/features/patient/features/doctors/presentation/widgets/doctor_profile_header.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({
    super.key,
    this.doctor,
  });

  final DoctorSummary? doctor;

  static const List<String> _timeSlots = [
    '01:30 PM',
    '3:00 PM',
    '5:00 PM',
    '7:00 PM',
    '9:00 PM',
    '10:00 PM',
  ];

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  late final ValueNotifier<DateTime?> _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = ValueNotifier<DateTime?>(DateTime.now());
  }

  @override
  void dispose() {
    _selectedDate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DoctorSummary profileDoctor =
        widget.doctor ??
        const DoctorSummary(
          id: 'dr_marvin_kinney',
          name: 'Dr. Marvin\nKinney',
          specialty: 'Cardiologist',
          rating: 4.8,
          reviewsCount: 82,
          imageAsset: AppAssets.avatar1,
        );

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
                    HorizontalCalenderMZ(
                      selectedDate: _selectedDate,
                      header: ValueListenableBuilder<DateTime?>(
                        valueListenable: _selectedDate,
                        builder: (context, selected, _) {
                          final DateTime value = selected ?? DateTime.now();
                          return Text(
                            '${_monthName(value.month)} ${value.year}',
                            style: AppStyles.black18500.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          );
                        },
                      ),
                      selectedbgcolor: AppColors.primary,
                      unselectedbgcolor: AppColors.background,
                      seldaynamecolor: AppColors.whiteText,
                      seldaynumbercolor: AppColors.primary,
                      unseldaynamecolor: AppColors.tertiaryText,
                      unseldaynumbercolor: AppColors.primaryText,
                      selectedbordercolor: Colors.transparent,
                      unselectedbordercolor: Colors.transparent,
                      calendericon: Icon(
                        Icons.chevron_right_rounded,
                        size: AppSizes.sp20,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    SizedBox(height: AppSizes.h24),
                    const DoctorAvailabilitySection(
                      timeSlots: DoctorProfileScreen._timeSlots,
                    ),
                    
                   SizedBox(height: AppSizes.h24),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
