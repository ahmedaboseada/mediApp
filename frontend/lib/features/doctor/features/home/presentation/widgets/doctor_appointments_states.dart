import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/home/data/models/doctor_appointment_model.dart';
import 'package:medi/features/doctor/features/home/presentation/widgets/doctor_appointments_table.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DoctorAppointmentsLoadingState extends StatelessWidget {
  const DoctorAppointmentsLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: DoctorAppointmentsTable(
        appointments: const [
          DoctorAppointmentModel(
            name: 'Loading patient',
            visitTime: '00:00 PM',
            avatarAsset: AppAssets.avatar1,
          ),
          DoctorAppointmentModel(
            name: 'Loading patient',
            visitTime: '00:00 PM',
            avatarAsset: AppAssets.avatar1,
          ),
          DoctorAppointmentModel(
            name: 'Loading patient',
            visitTime: '00:00 PM',
            avatarAsset: AppAssets.avatar1,
          ),
        ],
      ),
    );
  }
}

class DoctorAppointmentsEmptyState extends StatelessWidget {
  const DoctorAppointmentsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w16,
        vertical: AppSizes.h24,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(AppSizes.r32),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_busy_outlined,
            color: AppColors.secondaryText,
            size: AppSizes.sp32,
          ),
          SizedBox(height: AppSizes.h12),
          Text(
            'No appointments for this day',
            style: AppStyles.black14500,
          ),
          SizedBox(height: AppSizes.h6),
          Text(
            'Try another date to see scheduled patients.',
            style: AppStyles.secondary12400,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class DoctorAppointmentsErrorState extends StatelessWidget {
  const DoctorAppointmentsErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w16,
        vertical: AppSizes.h24,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(AppSizes.r32),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          Icon(
            Icons.cloud_off_outlined,
            color: AppColors.error,
            size: AppSizes.sp32,
          ),
          SizedBox(height: AppSizes.h12),
          Text(message, style: AppStyles.black14500, textAlign: TextAlign.center),
          SizedBox(height: AppSizes.h16),
          PrimaryButton(
            onPressed: onRetry,
            text: 'Retry',
          ),
        ],
      ),
    );
  }
}
