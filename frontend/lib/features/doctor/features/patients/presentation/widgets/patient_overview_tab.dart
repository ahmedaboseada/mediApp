import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/patients/data/models/patient_data.dart';
import 'package:medi/features/doctor/features/patients/presentation/widgets/patient_info_row.dart';
import 'package:medi/features/doctor/features/patients/presentation/widgets/patient_section_card.dart';
import 'package:medi/features/doctor/features/patients/presentation/widgets/patient_tag_chip.dart';

class PatientOverviewTab extends StatelessWidget {
  const PatientOverviewTab({super.key, required this.patient});

  final PatientData patient;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PatientSectionCard(
          title: 'Basic Information',
          icon: Icons.person_outline,
          child: Column(
            children: [
              PatientInfoRow(label: 'Patient ID:', value: patient.id),
              PatientInfoRow(label: 'Age', value: '${patient.age}'),
              PatientInfoRow(
                label: 'Gender:',
                value: patient.gender == 'female' ? '♀' : '♂',
                valueColor: patient.gender == 'female'
                    ? const Color(0xFFFF4D8D)
                    : const Color(0xFF2178F3),
                valueFontSize: AppSizes.sp24,
              ),
              PatientInfoRow(label: 'Blood Type:', value: patient.bloodType),
            ],
          ),
        ),
        SizedBox(height: AppSizes.h16),
        PatientSectionCard(
          title: 'Contact Information',
          icon: Icons.contact_page_outlined,
          child: Column(
            children: [
              PatientIconInfoRow(
                icon: Icons.call_outlined,
                text: patient.phone,
              ),
              SizedBox(height: AppSizes.h14),
              PatientIconInfoRow(
                icon: Icons.mail_outline,
                text:patient.email.isNotEmpty
                    ? patient.email :"email not provided", 
                    //'${patient.email.toLowerCase().replaceAll(' ', '.')}@email.com',
              ),
            ],
          ),
        ),
        SizedBox(height: AppSizes.h16),
        PatientSectionCard(
          title: 'Allergies',
          icon: Icons.back_hand_outlined,
          child: Wrap(
            spacing: AppSizes.w8,
            runSpacing: AppSizes.h8,
            children: patient.allergies.isNotEmpty
                ? patient.allergies.map((a) => PatientTagChip(text: a)).toList()
                : [Text('No known allergies', style: AppStyles.secondary12400)],
          ),
        ),
        SizedBox(height: AppSizes.h16),
        PatientSectionCard(
          title: 'Medical History',
          icon: Icons.assignment_outlined,
          child: Wrap(
            spacing: AppSizes.w8,
            runSpacing: AppSizes.h8,
            children: patient.chronicConditions.isNotEmpty
                ? patient.chronicConditions
                      .map((c) => PatientTagChip(text: c))
                      .toList()
                : [Text('No medical history', style: AppStyles.secondary12400)],
          ),
        ),
      ],
    );
  }
}
