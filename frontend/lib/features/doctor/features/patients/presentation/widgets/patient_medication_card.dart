import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/patients/presentation/widgets/medication_detail_col.dart';

class PatientMedicationCard extends StatelessWidget {
  const PatientMedicationCard({
    super.key,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.startDate,
    this.instructions,
  });

  final String name;
  final String dosage;
  final String frequency;
  final int startDate;
  final String? instructions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.w16),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(AppSizes.r24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
             SvgPicture.asset(AppAssets.meds, width: 24, height: 24, ),
              SizedBox(width: AppSizes.w12),
              Text(name, style: AppStyles.black16400),
            ],
          ),
          SizedBox(height: AppSizes.h16),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.w16,
              vertical: AppSizes.h16,
            ),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppSizes.r16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MedicationDetailCol(
                  icon: AppAssets.meds,
                  label: 'Dosage',
                  value: dosage,
                ),
                MedicationDetailCol(
                  icon: AppAssets.timer,
                  label: 'Frequency',
                  value: frequency,
                ),
                MedicationDetailCol(
                  icon: AppAssets.medicineBox,
                  label: 'Stock',
                  value: '$startDate',
                ),
              ],
            ),
          ),
          SizedBox(height: AppSizes.h12),
          Container(
            padding: EdgeInsets.all(AppSizes.w16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppSizes.r16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.description_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    SizedBox(width: AppSizes.w8),
                    Text('Instructions', style: AppStyles.black14500),
                  ],
                ),
                SizedBox(height: AppSizes.h8),
                Text(
                  instructions ?? 'No special instructions.',
                  style: AppStyles.secondary12400.copyWith(
                    fontSize: 14,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
