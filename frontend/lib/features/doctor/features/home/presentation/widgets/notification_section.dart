import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/settings/presentation/controller/cubit/notification_settings_cubit.dart';
import 'package:medi/features/doctor/features/settings/presentation/controller/cubit/notification_settings_state.dart';

class NotificationSection extends StatelessWidget {
  const NotificationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NotificationSettingsCubit>()..loadSettings(),
      child: const _NotificationSectionView(),
    );
  }
}

class _NotificationSectionView extends StatefulWidget {
  const _NotificationSectionView();

  @override
  State<_NotificationSectionView> createState() => _NotificationSectionViewState();
}

class _NotificationSectionViewState extends State<_NotificationSectionView> {
  void _handleAppointmentReminders(bool enable, BuildContext context) {
    context.read<NotificationSettingsCubit>().toggleAppointment(enable);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.w24),
        child: BlocBuilder<NotificationSettingsCubit, NotificationSettingsState>(
          builder: (context, state) {
            return Column(
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
                  value: state.emailNotifications,
                  onChanged: (value) => context.read<NotificationSettingsCubit>().toggleEmail(value),
                ),
                ToggleTile(
                  title: 'SMS Notifications',
                  subtitle: 'Receive notifications via text message',
                  value: state.smsNotifications,
                  onChanged: (value) => context.read<NotificationSettingsCubit>().toggleSms(value),
                ),
                ToggleTile(
                  title: 'Appointment Reminders',
                  subtitle: 'Get reminded about upcoming appointments',
                  value: state.appointmentReminders,
                  onChanged: (value) => _handleAppointmentReminders(value, context),
                ),
                ToggleTile(
                  title: 'Patient Updates',
                  subtitle: 'Notifications about patient status changes',
                  value: state.patientUpdates,
                  onChanged: (value) => context.read<NotificationSettingsCubit>().togglePatient(value),
                ),
                ToggleTile(
                  title: 'Medication Alerts',
                  subtitle: 'Alerts when patients miss medications',
                  value: state.medicationAlerts,
                  onChanged: (value) => context.read<NotificationSettingsCubit>().toggleMedication(value),
                ),
                ToggleTile(
                  title: 'System Updates',
                  subtitle: 'Important system and security updates',
                  value: state.systemUpdates,
                  onChanged: (value) => context.read<NotificationSettingsCubit>().toggleSystem(value),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
