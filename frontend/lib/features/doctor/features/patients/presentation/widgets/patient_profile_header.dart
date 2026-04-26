import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/patients/data/models/patient_data.dart';
import 'patient_status_pill.dart';

class PatientProfileHeader extends StatelessWidget {
  const PatientProfileHeader({
    super.key,
    required this.patient,
    required this.selectedTabIndex,
    required this.onTabChanged,
  });

  final PatientData patient;
  final int selectedTabIndex;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(AppSizes.r40),
          child: Container(
            width: AppSizes.w40,
            height: AppSizes.w40,
            decoration: BoxDecoration(
              color: AppColors.surfaceColor,
              borderRadius: BorderRadius.circular(AppSizes.r40),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 16,
              color: AppColors.secondaryText,
            ),
          ),
        ),
        SizedBox(height: AppSizes.h16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: AppSizes.r32,
              backgroundImage: NetworkImage(patient.avatarAsset),
            ),
            SizedBox(width: AppSizes.w16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(patient.name, style: AppStyles.black24700),
                  SizedBox(height: AppSizes.h8),
                  Row(
                    children: [
                      Text(
                        '${patient.age} Years',
                        style: AppStyles.secondary12400.copyWith(
                          fontSize: AppSizes.sp14,
                        ),
                      ),
                      SizedBox(width: AppSizes.w10),
                      Text(
                        patient.gender == 'female' ? '♀' : '♂',
                        style: TextStyle(
                          fontSize: AppSizes.sp22,
                          color: patient.gender == 'female'
                              ? const Color(0xFFFF4D8D)
                              : const Color(0xFF2178F3),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.h10),
                  Wrap(
                    spacing: AppSizes.w8,
                    runSpacing: AppSizes.h8,
                    children: [
                      PatientStatusPill(
                        text: patient.statusLabel,
                        color: patient.statusColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.h16),
        Container(
          padding: EdgeInsets.all(AppSizes.w4),
          decoration: BoxDecoration(
            color: AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(AppSizes.r40),
          ),
          child: Row(
            children: [
              PatientTopTab(
                label: 'Overview',
                selected: selectedTabIndex == 0,
                onTap: () => onTabChanged(0),
              ),
              PatientTopTab(
                label: 'Medications',
                selected: selectedTabIndex == 1,
                onTap: () => onTabChanged(1),
              ),
              PatientTopTab(
                label: 'Health Reports',
                selected: selectedTabIndex == 2,
                onTap: () => onTabChanged(2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PatientTopTab extends StatelessWidget {
  const PatientTopTab({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: AppSizes.h10),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSizes.r40),
          ),
          child: Text(
            label,
            style: AppStyles.black14500.copyWith(
              color: selected ? AppColors.whiteText : AppColors.quaternaryText,
            ),
          ),
        ),
      ),
    );
  }
}
