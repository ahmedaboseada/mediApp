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
    this.hint,
    this.search = true,
    this.validator,
    this.initialSelectedValues,
    this.semanticLabel,
  });
  final Function(List<String>) onSelectionChange;
  final List<DropdownItem<String>> items;
  final String label;
  final bool singleSelect;
  final String? hint;
  final bool? search;
  final String? Function(List<DropdownItem<String>>?)? validator;
  final List<String>? initialSelectedValues;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final updatedItems = items.map((item) {
      return DropdownItem<String>(
        label: item.label,
        value: item.value,
        selected: initialSelectedValues?.contains(item.value) ?? false,
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.black14600.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.start,
        ),
        Semantics(
          label: semanticLabel ?? label,
          hint: hint,
          child: MultiDropdown<String>(
            validator: validator,
            singleSelect: singleSelect,
            onSelectionChange: onSelectionChange,
            // (List<String> selectedList) {
            //   onSelectionChange(selectedList);
            //   print(selectedList);

            // },
            fieldDecoration: FieldDecoration(
              backgroundColor: AppColors.whiteText,
              hintStyle: AppStyles.black14500.copyWith(
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

            searchEnabled: search ?? true,
            dropdownDecoration: DropdownDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            items: updatedItems,
            // QuestionnaireConstants().allergies,
            dropdownItemDecoration: DropdownItemDecoration(
              selectedIcon: const Icon(
                textDirection: TextDirection.rtl,
                Icons.check_box_rounded,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
