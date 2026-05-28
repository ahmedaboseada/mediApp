import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/patients/data/models/patient_data.dart';

class PatientCard extends StatelessWidget {
  const PatientCard({super.key, required this.patient, this.onViewProfile});

  final PatientData patient;
  final VoidCallback? onViewProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(AppSizes.r40),
      ),
      padding: EdgeInsets.all(AppSizes.w16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar and Name Section
          Row(
            children: [
              CircleAvatar(
                radius: AppSizes.r20,
                child: ClipOval(
                  child: SizedBox(
                    width: AppSizes.r40,
                    height: AppSizes.r40,
                    child: patient.avatarAsset.isNotEmpty &&
                            patient.avatarAsset.toLowerCase().startsWith('http')
                        ? CachedNetworkImage(
                            imageUrl: patient.avatarAsset,
                            fit: BoxFit.cover,
                            fadeInDuration: Duration.zero,
                            placeholder: (_, __) => Image.asset(
                              AppAssets.avatar1,
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (_, __, ___) => Image.asset(
                              AppAssets.avatar1,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(AppAssets.avatar1, fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(width: AppSizes.w12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(patient.name, style: AppStyles.black14600),
                    Text(
                      'ID: ${patient.id}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.secondary12400,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.h8),

          // Patient Info Grid
          Column(
            children: [
              _InfoRow(label: 'Age', value: '${patient.age} years'),
              _InfoRow(
                label: 'Gender',
                value: patient.gender == 'M' ? '♂' : '♀',
                isIcon: true,
              ),
              _InfoRow(label: 'Blood Type', value: patient.bloodType),
            ],
          ),

          SizedBox(height: AppSizes.h8),

          // Status Badge
          _StatusBadge(patient: patient),

          SizedBox(height: AppSizes.h8),

          // View Profile Button
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              onPressed: onViewProfile,

              child: Text('View Profile', style: AppStyles.white14500),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.isIcon = false,
  });

  final String label;
  final String value;
  final bool isIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.h6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppStyles.secondary12400),
          Text(value, style: AppStyles.black14500),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.patient});

  final PatientData patient;

  @override
  Widget build(BuildContext context) {
    final statusColor = patient.statusColor;
    final statusLabel = patient.statusLabel;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w4,
        vertical: AppSizes.h4,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: statusColor, width: 1.5),
        borderRadius: BorderRadius.circular(AppSizes.r20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppSizes.w8,
            height: AppSizes.w8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: statusColor,
            ),
          ),
          SizedBox(width: AppSizes.w8),
          Text(
            statusLabel,
            style: AppStyles.secondary12400.copyWith(color: statusColor),
          ),
        ],
      ),
    );
  }
}
