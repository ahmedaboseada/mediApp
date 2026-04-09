import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: TextButton(
          onPressed: () => context.go(AppRouter.doctorCompleteProfile),
          child: const Text('Caregiver Mode'),
        ),
      ),
    );
  }
}
