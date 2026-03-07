import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class GenderField extends StatelessWidget {
  const GenderField({
    super.key,
    this.isEditing = true,
    this.onGenderChanged,
    required this.value,
    this.validator,
  });
  final bool isEditing;
  final Function(String)? onGenderChanged;
  final String value;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Gender', style: AppStyles.black14500),
        const SizedBox(height: 8),
        DropdownButtonFormField2<String>(
          validator: validator,
          // value: state.gender.isEmpty ? null : state.gender,
          items: ['male', 'female']
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(item),
                  ),
                ),
              )
              .toList(),

          onChanged: isEditing
              ? (value) {
                  if (value != null) {
                    onGenderChanged?.call(value);
                    // context.read<ProfileFormCubit>().onGenderChanged(value);
                  }
                }
              : null,

          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.whiteText,
            hintText: "Select",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          dropdownStyleData: DropdownStyleData(
            width: 350,

            offset: const Offset(0, 0),
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),

            elevation: 6,
          ),
        ),
      ],
    );
  }
}
