import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeField extends StatelessWidget {
  final Function(String)? onChanged;
  final Function(String)? onCompleted;

  const PinCodeField({super.key, this.onChanged, this.onCompleted});

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      scrollPadding: EdgeInsets.all(AppSizes.w20),
      keyboardType: TextInputType.number,
      //autoFocus: true,
      cursorColor: Colors.white,
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: AppSizes.sp18,
        fontWeight: FontWeight.w500,
      ),
      length: 6,
      obscureText: false,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(AppSizes.r8),
        fieldHeight: AppSizes.h50,
        fieldWidth: AppSizes.w50,
        borderWidth: 0.5,
        inactiveColor: Colors.white,
        inactiveFillColor: Colors.white,
        selectedColor: AppColors.primary,
        selectedFillColor: Colors.white,
        activeFillColor: AppColors.primary,
        activeColor: AppColors.primary,
      ),
      animationDuration: const Duration(milliseconds: 300),
      enableActiveFill: true,
      onCompleted:
          onCompleted ??
          (v) {
            // Default action
          },
      onChanged:
          onChanged ??
          (value) {
            // Default action
          },
      beforeTextPaste: (text) {
        return true;
      },
      appContext: context,
    );
  }
}
