import 'package:flutter/material.dart';

class SecondryButton extends StatelessWidget {
  const SecondryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => Navigator.pop(context),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        side: const BorderSide(color: Colors.white),
      ),
      child: const Text("Don’t allow"),
    );
  }
}
