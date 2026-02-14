import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class QTextField extends StatelessWidget {
  const QTextField({
    super.key,
    required this.onSelectionChange,
    required this.items,
    required this.label,
    this.singleSelect = false,
  });
  final Function(List<String>) onSelectionChange;
  final List<DropdownItem<String>> items;
  final String label;
  final bool singleSelect;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.buttonLabel.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.start,
        ),
        MultiDropdown<String>(
          singleSelect: singleSelect,
          onSelectionChange: onSelectionChange,
          // (List<String> selectedList) {
          //   onSelectionChange(selectedList);
          //   print(selectedList);

          // },
          fieldDecoration: FieldDecoration(
            backgroundColor: AppColors.whiteText,
            hintStyle: AppStyles.fieldLabel50014.copyWith(
              color: AppColors.secondaryText,
            ),
            padding: EdgeInsets.all(AppSizes.h12),
            suffixIcon: Transform.rotate(
              angle: 1.5708,
              child: Icon(Icons.chevron_right, color: AppColors.arrow),
            ),
            borderRadius: AppSizes.r8,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.r8),
              borderSide: const BorderSide(
                width: 1.5,
                color: AppColors.borderColor,
              ),
            ),
          ),
          enabled: true,

          searchEnabled: true,
          dropdownDecoration: DropdownDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          items: items,
          // QuestionnaireConstants().allergies,
          dropdownItemDecoration: DropdownItemDecoration(
            selectedIcon: const Icon(
              Icons.check_box_rounded,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
