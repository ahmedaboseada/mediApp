import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class DoctorAvailabilitySection extends StatelessWidget {
  const DoctorAvailabilitySection({
    super.key,
    required this.timeSlots,
    this.selectedTimeSlot,
    this.onTimeSlotSelected,
  });

  final List<String> timeSlots;
  final ValueNotifier<String?>? selectedTimeSlot;
  final ValueChanged<String>? onTimeSlotSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.w16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.r32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Today, Availability',
                style: AppStyles.black18500.copyWith(
                  fontWeight: FontWeight.w700,
                ),
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
          if (selectedTimeSlot != null)
            ValueListenableBuilder<String?>(
              valueListenable: selectedTimeSlot!,
              builder: (context, selected, _) {
                return _buildTimeSlots(selected);
              },
            )
          else
            _buildTimeSlots(null),
        ],
      ),
    );
  }

  Widget _buildTimeSlots(String? selected) {
    return Wrap(
      spacing: AppSizes.w12,
      runSpacing: AppSizes.h12,
      children: timeSlots.map((slot) {
        final isSelected = selected == slot;
        return GestureDetector(
          onTap: () => onTimeSlotSelected?.call(slot),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.w12,
              vertical: AppSizes.h10,
            ),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.surfaceColor,
              borderRadius: BorderRadius.circular(AppSizes.r20),
            ),
            child: Text(
              slot,
              style: AppStyles.black14500.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppColors.surfaceColor
                    : AppColors.primaryText,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
