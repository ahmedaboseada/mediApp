import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/patients/data/models/patient_data.dart';
import 'package:medi/features/doctor/features/patients/presentation/widgets/patient_medication_card.dart';

class PatientMedicationsTab extends StatelessWidget {
  const PatientMedicationsTab({
    super.key,
    required this.patient,
    this.showAddMedicationAction = false,
    this.onAddMedication,
    this.onEditMedication,
    this.onDeleteMedication,
  });

  final PatientData patient;
  final bool showAddMedicationAction;
  final VoidCallback? onAddMedication;
  final VoidCallback? onEditMedication;
  final VoidCallback? onDeleteMedication;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Current Medications',
                style: AppStyles.black16400.copyWith(fontSize: 18),
              ),
            ),
            if (showAddMedicationAction)
              InkWell(
                borderRadius: BorderRadius.circular(AppSizes.r24),
                onTap: onAddMedication,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: AppColors.primary),
                ),
              ),
          ],
        ),
        SizedBox(height: AppSizes.h16),
        if (patient.medications.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppSizes.h24),
            child: Center(
              child: Text(
                'No medications found',
                style: AppStyles.secondary12400,
              ),
            ),
          )
        else
          ...patient.medications.map(
            (medication) => Padding(
              padding: EdgeInsets.only(bottom: AppSizes.h12),
              child: PatientMedicationCard(
                canEdit:showAddMedicationAction,
                onEdit: () => onEditMedication?.call(),
                onDelete: () => onDeleteMedication?.call(),
                name: medication.name,
                dosage: medication.dosage,
                frequency: medication.frequency,
                startDate: medication
                    .stock, // Assuming createdAt is the start date. Adjust if there's a specific start date field.
                instructions:
                    'Type: ${medication.type} • Status: ${medication.status} • Stock: ${medication.stock}',
              ),
            ),
          ),
      ],
    );
  }
}
