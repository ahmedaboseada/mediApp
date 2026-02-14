import 'package:flutter/material.dart';

class MultiSelectField extends StatelessWidget {
  const MultiSelectField({
    super.key,
    required this.label,
    required this.values,
    required this.options,
    required this.onChanged,
  });
  final String label;
  final List<String> values;
  final List<String> options;
  final ValueChanged<List<String>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8.0),
      ],
    );
  }
}
