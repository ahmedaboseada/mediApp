import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/home/presentation/widgets/notification_tile.dart';

class NotificationSection extends StatelessWidget {
  const NotificationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r40),
        side: BorderSide(color: AppColors.cardBorderColor, width: 1),
      ),
      color: AppColors.whiteText,
      elevation: 0,
      child: Column(
        children: [
          Text(
            'Notifications',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SwitchTile(
            title: 'Appointment Reminders',
            value: true,
            onChanged: (value) {},
          ),
          SwitchTile(
            title: 'New Messages',
            value: false,
            onChanged: (value) {},
          ),
          SwitchTile(
            title: 'Promotional Offers',
            value: true,
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }
}
