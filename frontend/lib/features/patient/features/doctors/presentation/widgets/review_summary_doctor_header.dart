import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/doctors/data/models/doctor_summary.dart';

class ReviewSummaryDoctorHeader extends StatelessWidget {
  const ReviewSummaryDoctorHeader({
    super.key,
    required this.doctor,
    required this.location,
  });

  final DoctorModel doctor;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.r80),
          child: doctor.user.profilePicture.startsWith('http')
              ? CachedNetworkImage(
                  imageUrl: doctor.user.profilePicture,
                  width: AppSizes.w64,
                  height: AppSizes.h64,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    AppAssets.avatar1,
                    width: AppSizes.w64,
                    height: AppSizes.h64,
                    fit: BoxFit.cover,
                  ),
                )
              : Image.asset(
                  doctor.user.profilePicture.isNotEmpty
                      ? doctor.user.profilePicture
                      : AppAssets.avatar1,
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
              Text(
                "${doctor.user.firstName} ${doctor.user.lastName}".replaceAll(
                  '\n',
                  ' ',
                ),
                style: AppStyles.black18500,
              ),
              SizedBox(height: AppSizes.h4),
              Text(doctor.specialization, style: AppStyles.secondary12400),
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
