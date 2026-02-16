import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/home/presentation/widgets/notification_section.dart';
import 'package:medi/features/doctor/features/home/presentation/widgets/settings_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SettingsSection(),
            SizedBox(height: AppSizes.h24),
            NotificationSection(),
            const Center(child: Text('Home rere Screen')),
            ToggleButtons(
              isSelected: [true],
              onPressed: (index) {},
              children: [Icon(Icons.add_ic_call_outlined)],
            ),
          ],
        ),
      ),
    );
  }
}
