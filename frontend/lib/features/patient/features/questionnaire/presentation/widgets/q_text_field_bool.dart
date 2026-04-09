import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:medi/core/core.dart';

class QTextFieldBoolean extends StatelessWidget {
  const QTextFieldBoolean({
    super.key,
    required this.onSelectionChange,
    required this.label,
    this.singleSelect = true,
  });

  final Function(bool) onSelectionChange;
  final String label;
  final bool singleSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.black14600.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.start,
        ),
        MultiDropdown<bool>(
          singleSelect: singleSelect,
          onSelectionChange: (selectedList) {
            if (selectedList.isNotEmpty) {
              onSelectionChange(selectedList[0]);
            }
          },
          fieldDecoration: FieldDecoration(
            backgroundColor: AppColors.whiteText,
            hintStyle: AppStyles.black14500.copyWith(
              color: AppColors.secondaryText,
            ),

            padding: const EdgeInsets.all(12),
            suffixIcon: Transform.rotate(
              angle: 1.5708,
              child: const Icon(Icons.chevron_right, color: AppColors.arrow),
            ),
            borderRadius: 8,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                width: 1.5,
                color: AppColors.borderColor,
              ),
            ),
          ),
          enabled: true,
          dropdownDecoration: DropdownDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          items: [
            DropdownItem<bool>(value: true, label: 'Yes'),
            DropdownItem<bool>(value: false, label: 'No'),
          ],
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
