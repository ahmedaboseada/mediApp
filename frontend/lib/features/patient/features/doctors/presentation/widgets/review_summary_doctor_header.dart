import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/doctors/data/models/doctor_summary.dart';

class ReviewSummaryDoctorHeader extends StatelessWidget {
  const ReviewSummaryDoctorHeader({
    super.key,
    required this.doctor,
    required this.location,
  });

  final DoctorSummary doctor;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.r80),
          child: Image.asset(
            doctor.imageAsset,
            width: AppSizes.w64,
            height: AppSizes.h64,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: AppSizes.w12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(doctor.name, style: AppStyles.black18500),
              SizedBox(height: AppSizes.h4),
              Text(doctor.specialty, style: AppStyles.secondary12400),
              SizedBox(height: AppSizes.h6),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: AppSizes.sp14,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: AppSizes.w4),
                  Expanded(
                    child: Text(
                      location,
                      style: AppStyles.secondary12400,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
