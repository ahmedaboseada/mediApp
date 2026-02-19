import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.hintText,
    this.controller,
    this.validator,
    this.keyboardType,
    this.isPassword = false,
    this.readOnly = false,
    this.autofillHints,
    required this.label,
  });

  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool isPassword;
  final bool readOnly;
  final Iterable<String>? autofillHints;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppStyles.black14500),
        SizedBox(height: AppSizes.h6),
        TextFormField(
          // onTapOutside: (_) {
          //   FocusScope.of(context).unfocus();
          // },
          textInputAction: TextInputAction.next,
          autofillHints: widget.autofillHints,
          readOnly: widget.readOnly,
          controller: widget.controller,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          obscuringCharacter: '*',
          obscureText: widget.isPassword ? _obscure : false,
          style: AppStyles.black14500.copyWith(
            color: AppColors.secondaryText,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surfaceColor,
            hintText: widget.hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.r10),
              borderSide: BorderSide(color: AppColors.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.r10),
              borderSide: BorderSide(color: AppColors.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.r10),
              borderSide: BorderSide(color: AppColors.focusedBorderColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.r10),
              borderSide: BorderSide(color: AppColors.errorBorderColor),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.r10),
              borderSide: BorderSide(color: AppColors.errorBorderColor),
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.primaryText,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
