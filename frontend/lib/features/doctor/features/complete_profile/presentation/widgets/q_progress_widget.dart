import 'package:flutter/material.dart';

class QProgressWidget extends StatelessWidget {
  const QProgressWidget({super.key, required this.step});
  final int step;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        2,
        (index) => Container(
          width: step == index ? 19 : 12,
          height: 12,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: step == index ? Colors.blue : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }
}
