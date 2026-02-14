import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/auth/presentation/cubit/log_out/log_out_cubit.dart';
import 'package:medi/features/patient/questionnaire/constants/constants.dart';
import 'package:medi/features/patient/questionnaire/presentation/widgets/multi_select_field.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:multiselect/multiselect.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  List<String> selected = [];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogOutCubit, LogOutState>(
      listener: (context, state) {
        if (state is LogOutSuccess) {
          context.go(AppRouter.selectScreen);
        } else if (state is LogOutFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        final isLoading = state is LogOutLoading;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Home'),

            actions: [
              IconButton(
                onPressed: isLoading
                    ? null
                    : () => context.read<LogOutCubit>().logOut(),
                icon: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.logout),
                tooltip: 'Logout',
              ),
            ],
          ),
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
                      (e) =>
                          DropdownItem<String>(label: e.label, value: e.label),
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
            ],
          ),
        );
      },
    );
  }
}
