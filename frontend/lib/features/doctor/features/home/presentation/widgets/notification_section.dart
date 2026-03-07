import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medi/core/core.dart';

class NotificationSection extends StatefulWidget {
  const NotificationSection({super.key});

  @override
  State<NotificationSection> createState() => _NotificationSectionState();
}

class _NotificationSectionState extends State<NotificationSection> {
  bool emailNotifications = false;
  bool smsNotifications = false;
  bool appointmentReminders = false;
  bool patientUpdates = false;
  bool medicationAlerts = false;
  bool systemUpdates = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.w24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  AppAssets.notification,
                  height: AppSizes.h20,
                  width: AppSizes.w20,
                ),
                SizedBox(width: AppSizes.w8),
                Text(
                  'Notification Preferences',
                  style: AppStyles.black14500.copyWith(fontSize: AppSizes.sp18),
                ),
              ],
            ),
            ToggleTile(
              title: 'Email Notifications',
              subtitle: 'Receive notifications via email',
              value: emailNotifications,
              onChanged: (value) {
                setState(() {
                  emailNotifications = value;
                });
              },
            ),
            ToggleTile(
              title: 'SMS Notifications',
              subtitle: 'Receive notifications via text message',
              value: smsNotifications,
              onChanged: (value) {
                setState(() {
                  smsNotifications = value;
                });
              },
            ),
            ToggleTile(
              title: 'Appointment Reminders',
              subtitle: 'Get reminded about upcoming appointments',
              value: appointmentReminders,
              onChanged: (value) {
                setState(() {
                  appointmentReminders = value;
                });
              },
            ),
            ToggleTile(
              title: 'Patient Updates',
              subtitle: 'Notifications about patient status changes',
              value: patientUpdates,
              onChanged: (value) {
                setState(() {
                  patientUpdates = value;
                });
              },
            ),
            ToggleTile(
              title: 'Medication Alerts',
              subtitle: 'Alerts when patients miss medications',
              value: medicationAlerts,
              onChanged: (value) {
                setState(() {
                  medicationAlerts = value;
                });
              },
            ),
            ToggleTile(
              title: 'System Updates',
              subtitle: 'Important system and security updates',
              value: systemUpdates,
              onChanged: (value) {
                setState(() {
                  systemUpdates = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
