import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/patients/data/models/patient_model.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({super.key, required this.patient});

  final PatientModel patient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppSizes.w16,
                  AppSizes.h12,
                  AppSizes.w16,
                  AppSizes.h16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Header(patient: patient),
                    SizedBox(height: AppSizes.h20),
                    _SectionCard(
                      title: 'Basic Information',
                      icon: Icons.person_outline,
                      child: Column(
                        children: [
                          _InfoRow(label: 'Patient ID:', value: patient.id),
                          _InfoRow(label: 'Age', value: '${patient.age}'),
                          _InfoRow(
                            label: 'Gender:',
                            value: patient.gender == 'F' ? '♀' : '♂',
                            valueColor: patient.gender == 'F'
                                ? const Color(0xFFFF4D8D)
                                : const Color(0xFF2178F3),
                            valueFontSize: AppSizes.sp24,
                          ),
                          _InfoRow(
                            label: 'Blood Type:',
                            value: patient.bloodType,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.h16),
                    _SectionCard(
                      title: 'Contact Information',
                      icon: Icons.contact_page_outlined,
                      child: Column(
                        children: [
                          _IconInfoRow(
                            icon: Icons.call_outlined,
                            text: '(20) 1289576249',
                          ),
                          SizedBox(height: AppSizes.h14),
                          _IconInfoRow(
                            icon: Icons.mail_outline,
                            text:
                                '${patient.name.toLowerCase().replaceAll(' ', '.')}@email.com',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.h16),
                    _SectionCard(
                      title: 'Allergies',
                      icon: Icons.back_hand_outlined,
                      child: Wrap(
                        spacing: AppSizes.w8,
                        runSpacing: AppSizes.h8,
                        children: const [
                          _TagChip(text: 'Penicillin'),
                          _TagChip(text: 'Peanuts'),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.h16),
                    _SectionCard(
                      title: 'Medical History',
                      icon: Icons.assignment_outlined,
                      child: Wrap(
                        spacing: AppSizes.w8,
                        runSpacing: AppSizes.h8,
                        children: const [
                          _TagChip(text: 'Hypertension'),
                          _TagChip(text: 'Type 2 Diabetes'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: AppSizes.h64),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.patient});

  final PatientModel patient;

  @override
  Widget build(BuildContext context) {
    return Column(
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
              backgroundImage: AssetImage(patient.avatarAsset),
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
                          fontSize: AppSizes.sp18,
                        ),
                      ),
                      SizedBox(width: AppSizes.w10),
                      Text(
                        patient.gender == 'F' ? '♀' : '♂',
                        style: TextStyle(
                          fontSize: AppSizes.sp22,
                          color: patient.gender == 'F'
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
                      _StatusPill(
                        text: patient.statusLabel,
                        color: patient.statusColor,
                      ),
                      const _StatusPill(
                        text: 'Abnormal',
                        color: Color(0xFFEDB64B),
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
            children: const [
              _TopTab(label: 'Overview', selected: true),
              _TopTab(label: 'Medications'),
              _TopTab(label: 'Health Reports'),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.w16),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(AppSizes.r40),
        border: Border.all(color: AppColors.borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: AppSizes.w24),
              SizedBox(width: AppSizes.w10),
              Text(
                title,
                style: AppStyles.black18500.copyWith(fontSize: AppSizes.sp20),
              ),
            ],
          ),
          SizedBox(height: AppSizes.h14),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.primaryText,
    this.valueFontSize,
  });

  final String label;
  final String value;
  final Color valueColor;
  final double? valueFontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.h8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppStyles.black16400.copyWith(fontSize: AppSizes.sp18),
            ),
          ),
          Text(
            value,
            style: AppStyles.black18500.copyWith(
              color: valueColor,
              fontSize: valueFontSize ?? AppSizes.sp18,
            ),
          ),
        ],
      ),
    );
  }
}

class _IconInfoRow extends StatelessWidget {
  const _IconInfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: AppSizes.w24),
        SizedBox(width: AppSizes.w12),
        Expanded(
          child: Text(
            text,
            style: AppStyles.black16400.copyWith(fontSize: AppSizes.sp16),
          ),
        ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w10,
        vertical: AppSizes.h6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFECEC),
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(color: const Color(0xFFFF5C5C), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFFF3D3D), size: 14),
          SizedBox(width: AppSizes.w4),
          Text(
            text,
            style: AppStyles.black14400.copyWith(
              color: const Color(0xFFFF3D3D),
              fontSize: AppSizes.sp16,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w10,
        vertical: AppSizes.h4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(AppSizes.r20),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: color, size: 14),
          SizedBox(width: AppSizes.w4),
          Text(
            text,
            style: AppStyles.black14400.copyWith(
              color: color,
              fontSize: AppSizes.sp14,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopTab extends StatelessWidget {
  const _TopTab({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
    );
  }
}
