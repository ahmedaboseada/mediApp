import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/shared/auth/presentation/cubit/complete_profile/complete_profile_cubit.dart';

class PhoneField extends StatelessWidget {
  const PhoneField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Phone Number', style: AppStyles.black14500),
        const SizedBox(height: 8),

        InternationalPhoneNumberInput(
          initialValue: PhoneNumber(isoCode: 'EG'),

          selectorConfig: SelectorConfig(
            selectorType: PhoneInputSelectorType.DROPDOWN,
            setSelectorButtonAsPrefixIcon: true,

            leadingPadding: 12,
            showFlags: false,
          ),

          onInputChanged: (number) {
            context.read<ProfileFormCubit>().onPhoneChanged(
              number.phoneNumber ?? '',
            );
            print('Phone number changed: ${number.phoneNumber}');
          },
          cursorColor: Colors.black,
          inputDecoration: InputDecoration(
            hintText: 'Enter Phone Number',

            hintStyle: TextStyle(color: Colors.grey.shade500),
            filled: true,
            fillColor: Colors.white,
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
  }
}
