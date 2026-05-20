import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/medicine_header_card.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/med_activity.dart';

class MedicineHistoryScreen extends StatelessWidget {
  const MedicineHistoryScreen({super.key, required this.medicine});
  final Medication medicine;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Medicine History')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MedicineHeaderCard(
              imagePath: AppAssets.getMedicineIcon(medicine.type),
              medicineName: medicine.name,
              subtitle: '${medicine.dosage} - ${medicine.frequency}',
            ),
            SizedBox(height: AppSizes.h16),
            const MedicationActivity(),
          ],
        ),
      ),
    );
  }
}
