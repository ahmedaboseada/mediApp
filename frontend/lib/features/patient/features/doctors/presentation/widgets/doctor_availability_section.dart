import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class DoctorAvailabilitySection extends StatelessWidget {
  const DoctorAvailabilitySection({
    super.key,
    required this.timeSlots,
  });

  final List<String> timeSlots;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.w16),
      decoration: BoxDecoration(
        color: const Color(0xFFE9EDF3),
        borderRadius: BorderRadius.circular(AppSizes.r32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Today, Availability',
                style: AppStyles.black18500.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Text(
                '${timeSlots.length} Stats',
                style: AppStyles.tertiary40012.copyWith(
                  color: AppColors.quaternaryText,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.h14),
          Wrap(
            spacing: AppSizes.w12,
            runSpacing: AppSizes.h12,
            children: timeSlots
                .map(
                  (slot) => Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.w12,
                      vertical: AppSizes.h10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceColor,
                      borderRadius: BorderRadius.circular(AppSizes.r20),
                    ),
                    child: Text(
                      slot,
                      style: AppStyles.black14500.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}