import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class CustomDropdown extends StatelessWidget {
  final String hint;
  final String label;
  final List<String> items;
  final Function(String) onChanged;

  const CustomDropdown({
    super.key,
    required this.hint,
    required this.items,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.black14500.copyWith(fontSize: AppSizes.sp14),
        ),
        SizedBox(height: AppSizes.h6),
        SizedBox(
          
          child: DropdownButtonFormField<String>(
            dropdownColor: AppColors.whiteText,
            
            icon: Transform.rotate(
              angle: 1.5708,
              child: Icon(Icons.chevron_right, color: AppColors.arrow),
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surfaceColor,
              hintText: hint,
              hintStyle: AppStyles.black14500.copyWith(
                color: AppColors.secondaryText,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.r10),
                borderSide: BorderSide(color: AppColors.borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.r10),
                borderSide: BorderSide(color: AppColors.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.r10),
                borderSide: BorderSide(color: AppColors.focusedBorderColor),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.r10),
                borderSide: BorderSide(color: AppColors.errorBorderColor),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.r10),
                borderSide: BorderSide(color: AppColors.errorBorderColor),
              ),
            ),
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) {
              if (value != null) onChanged(value);
            },
          ),
        ),
      ],
    );
  }
}
