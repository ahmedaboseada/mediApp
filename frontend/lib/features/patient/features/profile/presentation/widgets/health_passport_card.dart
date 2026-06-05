import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class HealthPassportCard extends StatefulWidget {
  const HealthPassportCard({
    super.key,
    required this.identity,
    required this.dateOfBirth,
    required this.bloodGroup,
    this.onDateOfBirthChanged,
    this.onBloodGroupChanged,
  });

  final String identity;
  final String dateOfBirth;
  final String bloodGroup;
  final ValueChanged<String>? onDateOfBirthChanged;
  final ValueChanged<String>? onBloodGroupChanged;

  @override
  State<HealthPassportCard> createState() => _HealthPassportCardState();
}

class _HealthPassportCardState extends State<HealthPassportCard> {
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController identityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateOfBirthController.text = widget.dateOfBirth;
    identityController.text = widget.identity;
    
    dateOfBirthController.addListener(() {
      widget.onDateOfBirthChanged?.call(dateOfBirthController.text);
    });
  }

  @override
  void dispose() {
    dateOfBirthController.dispose();
    identityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.w24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(label: 'Identity', controller: identityController),
            SizedBox(height: AppSizes.h16),
            DatePickerField(dateController: dateOfBirthController),
            SizedBox(height: AppSizes.h16),
            QTextField(
              search: false,
              singleSelect: true,
              label: 'Blood group',
              items: [
                DropdownItem(label: 'A+', value: 'A+'),
                DropdownItem(label: 'A-', value: 'A-'),
                DropdownItem(label: 'B+', value: 'B+'),
                DropdownItem(label: 'B-', value: 'B-'),
                DropdownItem(label: 'AB+', value: 'AB+'),
                DropdownItem(label: 'AB-', value: 'AB-'),
                DropdownItem(label: 'O+', value: 'O+'),
                DropdownItem(label: 'O-', value: 'O-'),
              ],
              onSelectionChange: (selected) {
                if (selected.isNotEmpty) {
                  widget.onBloodGroupChanged?.call(selected.first);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
