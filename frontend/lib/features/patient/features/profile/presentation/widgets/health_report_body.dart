import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/patients/data/models/patient_data.dart';
import 'package:medi/features/doctor/features/patients/presentation/widgets/patient_section_card.dart';
import 'package:medi/features/doctor/features/patients/presentation/widgets/section_card.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/medicine_card.dart';
import 'package:medi/features/doctor/features/patients/presentation/widgets/patient_tag_chip.dart';

class HealthReportBody extends StatelessWidget {
  const HealthReportBody({super.key, required this.patient});

  final PatientData patient;

  Medication _toSharedMedication(MedicationModel medication) {
    final status = medication.status.trim().toLowerCase();

    final stockStatus = medication.stock <= 10
        ? MedicationStockStatus.low
        : (medication.stock <= 20
              ? MedicationStockStatus.medium
              : MedicationStockStatus.good);

    return Medication(
      id: medication.id,
      name: medication.name,
      type: medication.type,
      dosage: medication.dosage,
      frequency: medication.frequency,
      stock: medication.stock,
      isChronic: medication.isChronic,
      isCriticalMode: status.contains('critical'),
      medicationType: Medication.medicationTypeFromLabel(medication.type),
      stockStatus: stockStatus,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PatientSectionCard(
          title: 'Routine Checkup',
          icon: Icons.calendar_today_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (patient.measurements.isEmpty)
                Text(
                  'No health measurements found',
                  style: AppStyles.secondary12400,
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: patient.measurements.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSizes.w10,
                    mainAxisSpacing: AppSizes.h10,
                    childAspectRatio: 1.35,
                  ),
                  itemBuilder: (context, index) {
                    final measurement = patient.measurements[index];

                    return Container(
                      padding: EdgeInsets.all(AppSizes.w12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(AppSizes.r16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              measurement.icon,
                              SizedBox(width: AppSizes.w8),
                              Expanded(
                                child: Text(
                                  measurement.status,
                                  style: AppStyles.secondary12400,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSizes.h8),
                          Text(measurement.value, style: AppStyles.black14500),
                          SizedBox(height: AppSizes.h4),
                          Text(
                            measurement.title,
                            style: AppStyles.secondary12400.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              SizedBox(height: AppSizes.h12),
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
        SectionCard(
          title: 'Medication History',
          child: patient.medications.isEmpty
              ? Text('No medication history', style: AppStyles.secondary12400)
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: patient.medications.length,
                  separatorBuilder: (_, _) => SizedBox(height: AppSizes.h10),
                  itemBuilder: (context, index) {
                    final medication = patient.medications[index];
                    final sharedMedication = _toSharedMedication(medication);

                    return MedicineCard(
                      medication: sharedMedication,
                      onTap: () {
                        context.push(
                          AppRouter.medicineHistoryScreen,
                          extra: sharedMedication,
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
