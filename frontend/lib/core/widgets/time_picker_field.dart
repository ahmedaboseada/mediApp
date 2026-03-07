import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class TimePickerField extends StatefulWidget {
  const TimePickerField({
    super.key,
    required this.label,
    this.onTimeSelected,
    this.validator,
  });

  final String label;
  final ValueChanged<TimeOfDay>? onTimeSelected;
  final String? Function(String?)? validator;


  @override
  State<TimePickerField> createState() => _TimePickerFieldState();
}


class _TimePickerFieldState extends State<TimePickerField> {
  final TextEditingController _timeController = TextEditingController();
  TimeOfDay? selectedTime;

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (time != null) {
      final formattedTime = time.format(context);
      setState(() {
        selectedTime = time;
        _timeController.text = formattedTime;
      });
      widget.onTimeSelected?.call(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Time Picker Field
        Expanded(
          child: CustomTextField(
            validator: widget.validator,
            readOnly: true,
            controller: _timeController,
            onTap: () {
              _pickTime();
            },
            label: widget.label,
            suffixIcon: Icon(Icons.access_time, color: AppColors.primary),
          ),
        ),
      
      ],
    )
    ;
  }
}