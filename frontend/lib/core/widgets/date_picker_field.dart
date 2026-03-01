import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:medi/core/core.dart';

class DatePickerField extends StatefulWidget {
  DatePickerField({super.key, this.initialDate, this.onDateSelected, required this.dateController});
  final DateTime? initialDate;
  final Function(DateTime)? onDateSelected;
  final TextEditingController dateController;





  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {

  Future<void> selectDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        String formattedDate = DateFormat('dd/MM/yyyy').format(date);
        widget.dateController.text = formattedDate;
      });
      widget.onDateSelected?.call(date);
    }
  }

  @override
  void initState() {
    super.initState();
    widget.dateController.text = widget.initialDate != null
        ? DateFormat('dd/MM/yyyy').format(widget.initialDate!)
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
          TextField(
            controller: widget.dateController,
            readOnly: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surfaceColor,
             // hintText: 'DD/MM/YYYY',

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
                onPressed: () {
                  selectDate();
                },
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
