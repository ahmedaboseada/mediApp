import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/widgets/common/app_button.dart';
import 'package:medi/features/patient/features/doctors/data/models/appointment_review_data.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key, required this.reviewData});

  final AppointmentReviewData reviewData;

  @override
  Widget build(BuildContext context) {
    final dateTimeParts = reviewData.dateAndHour.split('|');
    final date = dateTimeParts.first.trim();
    final time = dateTimeParts.length > 1
        ? dateTimeParts[1].trim()
        : '10:00 AM';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.w24,
            vertical: AppSizes.h16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              Container(
                width: 110,
                height: 110,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: AppColors.whiteText,
                  size: 56,
                  weight: 700,
                ),
              ),
              SizedBox(height: AppSizes.h24),
              Text(
                'Payment Successful!',
                style: AppStyles.black24700,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.h12),
              Text(
                'You have successfully booked appointment with',
                style: AppStyles.secondary12400,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.h4),
              Text(
                "${reviewData.doctor!.user.firstName} ${reviewData.doctor!.user.lastName}",
                style: AppStyles.black14500,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.h24),
              Divider(color: AppColors.borderColor),
              SizedBox(height: AppSizes.h16),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InfoItem(
                          assetPath: AppAssets.man,
                          text: reviewData.bookingFor,
                        ),
                        SizedBox(height: AppSizes.h24),
                        _InfoItem(assetPath: AppAssets.calendar, text: date),
                      ],
                    ),
                    SizedBox(width: AppSizes.w24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InfoItem(
                          assetPath: AppAssets.dollarCircle,
                          text: '\$${reviewData.amount.toStringAsFixed(0)}',
                        ),
                        SizedBox(height: AppSizes.h24),
                        _InfoItem(assetPath: AppAssets.timer, text: time),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 3),
              PrimaryButton(
                text: 'View Appointment',
                onPressed: () => context.push(
                  AppRouter.patientMyAppointmentScreen,
                  extra: reviewData,
                ),
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
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.assetPath, required this.text});

  final String assetPath;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          assetPath,
          width: AppSizes.w24,
          height: AppSizes.h24,
          colorFilter: const ColorFilter.mode(
            AppColors.primary,
            BlendMode.srcIn,
          ),
        ),
        SizedBox(width: AppSizes.w8),
        Text(
          text,
          style: AppStyles.black14500,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
