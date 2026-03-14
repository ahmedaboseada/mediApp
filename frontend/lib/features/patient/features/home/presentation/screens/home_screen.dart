import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/questionnaire/constants/constants.dart';
import 'package:medi/features/patient/features/questionnaire/presentation/widgets/multi_select_field.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  List<String> selected = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home'), actions: []),
      body: Column(
        children: [
          const Text('Home Screen'),
          MultiSelectField(
            label: 'Select your interests',
            values: const [],
            options: const ['Option 1', 'Option 2', 'Option 3'],
            onChanged: (selectedValues) {
              // Handle changes
            },
          ),
          MultiDropdown<String>(
            onSelectionChange: (List<String> selectedValues) {},
            enabled: true,
            searchEnabled: true,
            dropdownDecoration: DropdownDecoration(),
            items: QuestionnaireConstants().allergies
                .map(
                  (e) => DropdownItem<String>(label: e.label, value: e.label),
                )
                .toList(),
            dropdownItemDecoration: DropdownItemDecoration(
              selectedIcon: const Icon(
                Icons.check_box_rounded,
                color: AppColors.primary,
              ),
            ),
          ),

          TextButton(
            onPressed: () => context.go(AppRouter.onboardingFlow),
            child: const Text('Go to Questionnaire'),
          ),
          TextButton(
            onPressed: () => context.go(AppRouter.completeProfile),
            child: const Text('View Profile'),
          ),
          TextButton(
            onPressed: () => context.go(AppRouter.doctorCompleteProfile),
            child: const Text('Caregiver Mode'),
          ),
          TextButton(
            onPressed: () => context.go(AppRouter.healthMeasurements),
            child: const Text('Health Measurements'),
          ),
        ],
      ),
    );
  }
}
