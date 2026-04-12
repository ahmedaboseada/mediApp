import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class PatientDetailsScreen extends StatelessWidget {
  const PatientDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Patient Details'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.w16,
                  vertical: AppSizes.h12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    QTextField(
                      onSelectionChange: (List<String> value) {},
                      items: [DropdownItem(value: 'self', label: 'Self')],
                      label: 'Booking for',
                      hint: 'Self',
                      search: false,
                      singleSelect: true,
                    ),

                    SizedBox(height: AppSizes.h18),
                    CustomTextField(
                      label: 'your Age',
                      hintText: 'Enter your age',
                    ),
                    SizedBox(height: AppSizes.h18),
                    GenderField(value: ''),

                    SizedBox(height: AppSizes.h18),
                    CustomTextField(
                      label: 'Write Your Problem',
                      hintText: 'Write here...',
                      maxLines: 7,
                    ),
                    SizedBox(height: AppSizes.h24),
                    PrimaryButton(text: 'Next', onPressed: () {}),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
