import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/daily_symptoms/add_symptom_chip.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/daily_symptoms/symptom_chip.dart';

class SelectedSymptomsWrap extends StatelessWidget {
  const SelectedSymptomsWrap({
    super.key,
    required this.selectedSymptoms,
    required this.onRemove,
    required this.onAddTap,
  });

  final List<String> selectedSymptoms;
  final ValueChanged<String> onRemove;
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.w8,
      runSpacing: AppSizes.h8,
      children: <Widget>[
        ...selectedSymptoms.map(
          (String symptom) =>
              SymptomChip(label: symptom, onRemove: () => onRemove(symptom)),
        ),
        AddSymptomChip(onTap: onAddTap),
      ],
    );
  }
}
