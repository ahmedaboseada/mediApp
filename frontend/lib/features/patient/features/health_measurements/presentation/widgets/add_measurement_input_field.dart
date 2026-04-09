import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class AddMeasurementInputField extends StatelessWidget {
  const AddMeasurementInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: label,
      hintText: hintText,
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    );
  }
}
