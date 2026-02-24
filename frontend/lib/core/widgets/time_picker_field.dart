import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class TimePickerField extends StatefulWidget {
  const TimePickerField({super.key, required this.label});
  final String label;
  
   @override
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Time Picker Field
        Expanded(
          child: CustomTextField(
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