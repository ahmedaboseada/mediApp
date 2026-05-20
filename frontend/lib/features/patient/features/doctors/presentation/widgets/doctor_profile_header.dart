import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/doctors/data/models/doctor_summary.dart';
import 'package:medi/features/patient/features/doctors/presentation/widgets/zigzag_bottom_clipper.dart';

class DoctorProfileHeader extends StatelessWidget {
  const DoctorProfileHeader({
    super.key,
    required this.doctor,
    this.onBack,
    this.onInsightsTap,
  });

  final Doctordata doctor;
  final VoidCallback? onBack;
  final VoidCallback? onInsightsTap;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ZigzagBottomClipper(
        minDepth: AppSizes.h8,
        maxDepth: AppSizes.h38,
        segmentWidth: AppSizes.w20,
        seed: 20,
      ),
      child: Container(
        padding: EdgeInsets.all(AppSizes.w16),
        decoration: BoxDecoration(color: const Color(0xFFDDE8F8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _CircleIconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: onBack,
                ),
                _CircleIconButton(
                  icon: Icons.chat_bubble_outline_outlined,
                  iconColor: AppColors.primary,
                  onTap: onInsightsTap,
                ),
              ],
            ),
            SizedBox(height: AppSizes.h8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: AppSizes.h18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.specialization,
                          style: AppStyles.tertiary14500.copyWith(
                            color: AppColors.quaternaryText,
                          ),
                        ),
                        SizedBox(height: AppSizes.h4),
                        Text(
                          "${doctor.user.firstName} ${doctor.user.lastName}"
                              .replaceAll('\n', ' '),
                          style: AppStyles.black18500.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(height: AppSizes.h8),
                        Row(
                          children: [
                            Icon(
                              Icons.qr_code_2_rounded,
                              size: AppSizes.sp20,
                              color: AppColors.primaryText,
                            ),
                            SizedBox(width: AppSizes.w8),
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSizes.w10,
                                  vertical: AppSizes.h6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceColor,
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.r20,
                                  ),
                                ),
                                child: Text(
                                  'ID:${doctor.id}',
                                  style: AppStyles.tertiary40012.copyWith(
                                    color: AppColors.secondaryText,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSizes.h10),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.w12,
                            vertical: AppSizes.h6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(AppSizes.r20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                color: AppColors.surfaceColor,
                                size: AppSizes.sp14,
                              ),
                              SizedBox(width: AppSizes.w4),
                              Text(
                                'Rating ${doctor.reviewsCount.toStringAsFixed(1)}',
                                style: AppStyles.white12400.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: AppSizes.w8),
                Hero(
                  tag: doctor.id,
                  child:
                      (doctor.user.profilePicture.isNotEmpty &&
                          doctor.user.profilePicture.startsWith('http'))
                      ? CachedNetworkImage(
                          imageUrl: doctor.user.profilePicture,
                          height: AppSizes.h170,
                          fit: BoxFit.contain,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Image.asset(
                            AppAssets.avatar1,
                            height: AppSizes.h170,
                            fit: BoxFit.contain,
                          ),
                        )
                      : Image.asset(
                          doctor.user.profilePicture.isNotEmpty
                              ? doctor.user.profilePicture
                              : AppAssets.avatar1,
                          height: AppSizes.h170,
                          fit: BoxFit.contain,
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, this.onTap, this.iconColor});

  final IconData icon;
  final VoidCallback? onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceColor,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          height: AppSizes.h36,
          width: AppSizes.h36,
          child: Icon(
            icon,
            color: iconColor ?? AppColors.secondaryText,
            size: AppSizes.sp18,
          ),
        ),
      ),
    );
  }
}
