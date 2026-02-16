import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class SwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SwitchTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Transform.scale(
            scale: 0.9, // 👈 يصغر الحجم شوية لو حابة
            child: FlutterSwitch(
              width: 64,
              height: 28,
              toggleSize: 24, // حجم الدايرة البيضاء
              borderRadius: 14, // نصف ارتفاع الشكل → بيضاوي كامل
              padding: 2, // المسافة بين الدايرة والحافة
              toggleColor: Colors.white,
              activeColor: Colors.green,
              inactiveColor: Colors.grey[300]!,
              value: value,
              onToggle: (val) {
                onChanged(val);
              },
            ),
          ),
        ],
      ),
    );
  }
}
