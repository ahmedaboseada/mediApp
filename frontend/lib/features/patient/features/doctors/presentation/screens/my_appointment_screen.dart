import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/doctors/data/models/appointment_review_data.dart';
import 'package:medi/features/patient/features/doctors/presentation/widgets/review_summary_doctor_header.dart';

class MyAppointmentScreen extends StatelessWidget {
  const MyAppointmentScreen({super.key, this.reviewData});

  final AppointmentReviewData? reviewData;

  @override
  Widget build(BuildContext context) {
    final data = reviewData!;
    final dateTimeParts = data.dateAndHour.split('|');
    final date = dateTimeParts.first.trim();
    final time = dateTimeParts.length > 1
        ? dateTimeParts[1].trim()
        : '10:00 AM';
    final timeRange = _buildTimeRange(time, data.duration);

    return Scaffold(
      appBar: const CustomAppBar(title: 'My Appointment'),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.w16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppSizes.h12),
              ReviewSummaryDoctorHeader(
                doctor: data.doctor!,
                location: data.location,
              ),
              SizedBox(height: AppSizes.h12),
              Divider(color: AppColors.borderColor),
              SizedBox(height: AppSizes.h10),
              Text('Scheduled Appointment', style: AppStyles.black24700),
              SizedBox(height: AppSizes.h8),
              _InfoLine(title: 'Date', value: date),
              SizedBox(height: AppSizes.h10),
              _InfoLine(title: 'Time', value: timeRange),
              SizedBox(height: AppSizes.h10),
              _InfoLine(title: 'Booking for', value: data.bookingFor),
              SizedBox(height: AppSizes.h12),
              Divider(color: AppColors.borderColor),
              SizedBox(height: AppSizes.h10),
              Text('Patient Info.', style: AppStyles.black24700),
              SizedBox(height: AppSizes.h8),
              const _InfoLine(title: 'Full Name', value: 'Esther Howard'),
              SizedBox(height: AppSizes.h10),
              const _InfoLine(title: 'Gender', value: 'Male'),
              SizedBox(height: AppSizes.h10),
              const _InfoLine(title: 'Age', value: '27'),
              SizedBox(height: AppSizes.h10),
              const _InfoLine(title: 'Problem', value: 'Lorem Ipsum dolor'),
              SizedBox(height: AppSizes.h12),
              Divider(color: AppColors.borderColor),
              SizedBox(height: AppSizes.h10),
              Text('Package', style: AppStyles.black24700),
              SizedBox(height: AppSizes.h10),
              Container(
                padding: EdgeInsets.all(AppSizes.w12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceColor,
                  borderRadius: BorderRadius.circular(AppSizes.r12),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEAF2FF),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppAssets.video,
                          width: AppSizes.w20,
                          height: AppSizes.h20,
                          colorFilter: const ColorFilter.mode(
                            AppColors.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSizes.w10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${data.packageName} appointment',
                            style: AppStyles.black14500,
                          ),
                          Text(
                            'Video call with doctor',
                            style: AppStyles.secondary12400,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${data.amount.toStringAsFixed(0)}',
                          style: AppStyles.black14500,
                        ),
                        const Text(
                          'Paid',
                          style: TextStyle(
                            color: Color(0xFF16A34A),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSizes.h18),
              PrimaryButton(
                text: 'View Other Appointments',
                onPressed: () => context.go('/doctors/my-bookings'),
              ),
              SizedBox(height: AppSizes.h8),
              TextButton(
                onPressed: () => context.go('/home'),
                child: Text(
                  'Go Home',
                  style: AppStyles.secondary12400.copyWith(
                    color: AppColors.tertiaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: AppSizes.h8),
            ],
          ),
        ),
      ),
    );
  }

  String _buildTimeRange(String startTime, String duration) {
    final parsedDuration = int.tryParse(
      RegExp(r'\d+').firstMatch(duration)?.group(0) ?? '',
    );
    if (parsedDuration == null) {
      return '$startTime ($duration)';
    }

    try {
      final start = DateFormat('h:mm a').parse(startTime);
      final end = start.add(Duration(minutes: parsedDuration));
      final endTime = DateFormat('h:mm a').format(end);
      return '$startTime - $endTime ($duration)';
    } catch (_) {
      return '$startTime ($duration)';
    }
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: AppStyles.secondary12400),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            style: AppStyles.black14500,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
