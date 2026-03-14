import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class DailySymptomsNotesField extends StatelessWidget {
  const DailySymptomsNotesField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: '',
      hintText: 'Add Notes...',
      controller: controller,
      maxLines: 3,
      keyboardType: TextInputType.multiline,
    );
  }
}
