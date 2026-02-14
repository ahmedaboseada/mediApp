import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/auth/presentation/cubit/complete_profile/complete_profile_cubit.dart';
import 'package:medi/features/auth/presentation/cubit/complete_profile/complete_profile_state.dart';

class GenderField extends StatelessWidget {
  const GenderField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileFormCubit, ProfileFormState>(
      buildWhen: (p, c) => p.gender != c.gender,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Gender', style: AppStyles.fieldLabel50014),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              style: AppStyles.fieldLabel50014.copyWith(
                color: AppColors.secondaryText,
              ),
              initialValue: state.gender.isEmpty ? null : state.gender,
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('Male')),
                DropdownMenuItem(value: 'Female', child: Text('Female')),
              ],
              onChanged: (value) {
                if (value != null) {
                  context.read<ProfileFormCubit>().onGenderChanged(value);
                }
              },

              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Select',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
