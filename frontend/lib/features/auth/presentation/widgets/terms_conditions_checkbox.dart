import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class TermsConditionsCheckbox extends StatelessWidget {
  const TermsConditionsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          activeColor: AppColors.primary,
          side: BorderSide(color: AppColors.borderColor),
          onChanged: (checked) => onChanged(checked ?? false),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(!value),
            child: Text.rich(
              TextSpan(
                text: 'Agree with ',
                style: AppStyles.bodyText.copyWith(
                  color: AppColors.secondaryText,
                ),
                children: [
                  TextSpan(
                    text: 'Terms & Conditions',
                    style: AppStyles.bodyText.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
