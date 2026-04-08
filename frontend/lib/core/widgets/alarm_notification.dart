import 'package:flutter/material.dart';

class AlarmScreen extends StatelessWidget {
  final String medicineName;

  const AlarmScreen({super.key, required this.medicineName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade700,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.medication, size: 100, color: Colors.white),
            const SizedBox(height: 20),
            Text(
              medicineName,
              style: const TextStyle(fontSize: 28, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              "Time to take your medicine",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 40),

            // ✅ Take
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Taken"),
            ),

            const SizedBox(height: 20),

            // ❌ Dismiss
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Dismiss"),
            ),
          ],
        ),
      ),
    );
  }
}