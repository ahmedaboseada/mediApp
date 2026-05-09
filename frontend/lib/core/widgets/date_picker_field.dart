import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:medi/core/core.dart';

class DatePickerField extends StatefulWidget {
  const DatePickerField({
    super.key,
    this.initialDate,
    this.onDateSelected,
    required this.dateController,
    this.enabled = true,
    this.validator, 
  });
  final DateTime? initialDate;
  final Function(DateTime)? onDateSelected;
  final TextEditingController dateController;
  final bool enabled;
  final String? Function(String?)? validator;

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  Future<void> selectDate() async {
    if (!widget.enabled) {
      return;
    }

    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        String formattedDate = DateFormat('yyyy').format(date);
        widget.dateController.text = formattedDate;
      });
      widget.onDateSelected?.call(date);
    }
  }

  @override
  void initState() {
    super.initState();
    widget.dateController.text = widget.initialDate != null
        ? DateFormat('yyyy').format(widget.initialDate!)
        : '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.h10),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Year of birth', style: AppStyles.black14500),
          SizedBox(height: AppSizes.h8),
          TextFormField(
            controller: widget.dateController,
            enabled: widget.enabled,
            readOnly: true,
            validator: widget.validator,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surfaceColor,

              // hintText: 'YYYY',
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

              suffixIcon: IconButton(
                onPressed: widget.enabled ? selectDate : null,
                icon: SvgPicture.asset(
                  AppAssets.calendar,
                  height: AppSizes.h24,
                  width: AppSizes.w24,
                  fit: BoxFit.scaleDown,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primaryDark,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
