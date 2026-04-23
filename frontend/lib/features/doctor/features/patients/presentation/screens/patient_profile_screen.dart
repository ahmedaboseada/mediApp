import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/patients/data/models/patient_model.dart';
import 'package:medi/features/doctor/features/patients/presentation/widgets/patient_medication_card.dart';
import 'package:medi/features/doctor/features/patients/presentation/widgets/patient_profile_header.dart';
import 'package:medi/features/doctor/features/patients/presentation/widgets/patient_section_card.dart';
import 'package:medi/features/doctor/features/patients/presentation/widgets/patient_info_row.dart';
import 'package:medi/features/doctor/features/patients/presentation/widgets/patient_tag_chip.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key, required this.patient});

  final PatientModel patient;

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  int _selectedTabIndex = 0;

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
                    PatientProfileHeader(
                      patient: widget.patient,
                      selectedTabIndex: _selectedTabIndex,
                      onTabChanged: (index) {
                        setState(() {
                          _selectedTabIndex = index;
                        });
                      },
                    ),
                    SizedBox(height: AppSizes.h20),
                    if (_selectedTabIndex == 0) ...[
                      PatientSectionCard(
                        title: 'Basic Information',
                        icon: Icons.person_outline,
                        child: Column(
                          children: [
                            PatientInfoRow(
                              label: 'Patient ID:',
                              value: widget.patient.id,
                            ),
                            PatientInfoRow(
                              label: 'Age',
                              value: '${widget.patient.age}',
                            ),
                            PatientInfoRow(
                              label: 'Gender:',
                              value: widget.patient.gender == 'F' ? '♀' : '♂',
                              valueColor: widget.patient.gender == 'F'
                                  ? const Color(0xFFFF4D8D)
                                  : const Color(0xFF2178F3),
                              valueFontSize: AppSizes.sp24,
                            ),
                            PatientInfoRow(
                              label: 'Blood Type:',
                              value: widget.patient.bloodType,
                            ),
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
                              text: widget.patient.phone,
                            ),
                            SizedBox(height: AppSizes.h14),
                            PatientIconInfoRow(
                              icon: Icons.mail_outline,
                              text:
                                  '${widget.patient.name.toLowerCase().replaceAll(' ', '.')}@email.com',
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
                          children: widget.patient.allergies.isNotEmpty
                              ? widget.patient.allergies
                                  .map((a) => PatientTagChip(text: a))
                                  .toList()
                              : [
                                  Text(
                                    'No known allergies',
                                    style: AppStyles.secondary12400,
                                  )
                                ],
                        ),
                      ),
                      SizedBox(height: AppSizes.h16),
                      PatientSectionCard(
                        title: 'Medical History',
                        icon: Icons.assignment_outlined,
                        child: Wrap(
                          spacing: AppSizes.w8,
                          runSpacing: AppSizes.h8,
                          children: widget.patient.chronicConditions.isNotEmpty
                              ? widget.patient.chronicConditions
                                  .map((c) => PatientTagChip(text: c))
                                  .toList()
                              : [
                                  Text(
                                    'No medical history',
                                    style: AppStyles.secondary12400,
                                  )
                                ],
                        ),
                      ),
                    ],
                    if (_selectedTabIndex == 1) ...[
                      Text(
                        'Current Medications',
                        style: AppStyles.black16400.copyWith(fontSize: 18),
                      ),
                      SizedBox(height: AppSizes.h16),
                      PatientMedicationCard(
                        name: 'Lisinopril',
                        dosage: '10mg',
                        frequency: 'Once daily',
                        startDate: '2026-01-15',
                        instructions: 'Take in the morning with water',
                      ),
                    ],
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
