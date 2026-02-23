import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/auth/presentation/cubit/complete_profile/complete_profile_cubit.dart';
import 'package:medi/features/auth/presentation/cubit/complete_profile/complete_profile_state.dart';

class GenderField extends StatelessWidget {
  const GenderField({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<ProfileFormCubit, ProfileFormState>(
        buildWhen: (p, c) => p.gender != c.gender,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Gender', style: AppStyles.black14500),
              const SizedBox(height: 8),
              DropdownButtonFormField2<String>(
  value: state.gender.isEmpty ? null : state.gender,

  items: ['Male', 'Female']
      .map(
        (item) => DropdownMenuItem(
          value: item,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(item),
          ),
        ),
      )
      .toList(),

  onChanged: (value) {
    if (value != null) {
      context.read<ProfileFormCubit>().onGenderChanged(value);
    }
    
  },

  decoration: InputDecoration(
    hintText: "Select",
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),

  dropdownStyleData: DropdownStyleData(
    width: 350,

     offset: const Offset(0, 0), // Adjust the offset to move the menu towards the text
      padding: const EdgeInsets.symmetric(vertical: 4),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: Colors.white,
    ),

    elevation: 6,
  ),
)

            ],
          );
        },
    );
  }
}
