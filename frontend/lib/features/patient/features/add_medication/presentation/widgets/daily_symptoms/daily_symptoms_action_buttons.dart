import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class DailySymptomsActionButtons extends StatelessWidget {
  const DailySymptomsActionButtons({
    super.key,
    required this.onSave,
    required this.onClear,
  });

  final VoidCallback onSave;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: PrimaryButton(text: 'Save', onPressed: onSave),
        ),
        SizedBox(width: AppSizes.w12),
        Expanded(
          child: PrimaryButton(
            text: 'Clear',
            backgroundColor: AppColors.secondary,
            textColor: AppColors.primary,
            onPressed: onClear,
          ),
        ),
      ],
    );
  }
}
