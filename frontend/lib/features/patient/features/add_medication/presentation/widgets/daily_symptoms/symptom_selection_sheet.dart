import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

const List<String> _allSymptoms = <String>[
  'Headache',
  'Fever',
  'Fatigue',
  'Nausea',
  'Dizziness',
  'Cough',
  'Sore throat',
  'Muscle pain',
];

Future<String?> showSymptomSelectionSheet(
  BuildContext context, {
  required List<String> selectedSymptoms,
}) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: AppColors.surfaceColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.r24)),
    ),
    builder: (BuildContext context) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSizes.w16,
            AppSizes.h12,
            AppSizes.w16,
            AppSizes.h16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Choose Symptom',
                style: AppStyles.black18500.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: AppSizes.h8),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _allSymptoms.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String symptom = _allSymptoms[index];
                    final bool alreadyAdded = selectedSymptoms.contains(
                      symptom,
                    );
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        symptom,
                        style: AppStyles.black14500.copyWith(
                          color: alreadyAdded
                              ? AppColors.tertiaryText
                              : AppColors.primaryText,
                        ),
                      ),
                      trailing: alreadyAdded
                          ? Icon(
                              Icons.check,
                              color: AppColors.primary,
                              size: AppSizes.sp20,
                            )
                          : null,
                      onTap: alreadyAdded
                          ? null
                          : () => Navigator.of(context).pop(symptom),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
