import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/section_item_tile.dart';
import 'package:medi/features/shared/auth/presentation/cubit/log_out/log_out_cubit.dart';

class SettingsSection extends StatefulWidget {
  const SettingsSection({super.key});

  @override
  State<SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<SettingsSection> {
  late bool notifications;
  late bool earlyVoiceAlerts;

  @override
  void initState() {
    super.initState();
    notifications = HiveService.getNotificationsEnabled();
    earlyVoiceAlerts = HiveService.getEarlyVoiceAlerts();
  }

  Future<void> _onNotificationsChanged(bool value) async {
    setState(() {
      notifications = value;
    });

    // Persist the setting
    await HiveService.setNotificationsEnabled(value);

    final medications = HiveService.getMedications();
    final notificationService = LocalNotificationService();

    if (value) {
      // Turned ON: reschedule all medication notifications
      for (final medication in medications) {
        await notificationService.scheduleMedicationReminders(medication);
      }
    } else {
      // Turned OFF: cancel all medication notifications
      for (final medication in medications) {
        await notificationService.cancelMedicationReminders(medication);
      }
    }
  }

  Future<void> _onEarlyVoiceAlertsChanged(bool value) async {
    setState(() {
      earlyVoiceAlerts = value;
    });

    // Persist the setting
    await HiveService.setEarlyVoiceAlerts(value);

    // Reschedule all medication notifications with the new setting
    final medications = HiveService.getMedications();
    final notificationService = LocalNotificationService();
    for (final medication in medications) {
      await notificationService.rescheduleMedicationReminders(
        previousMedication: medication,
        updatedMedication: medication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogOutCubit, LogOutState>(
      listener: (context, state) {
        if (state is LogOutSuccess) {
          context.go(AppRouter.selectScreen);
        } else if (state is LogOutFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        final isLoading = state is LogOutLoading;

        return Card(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.w16),
            child: Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      AppAssets.settings,
                      height: AppSizes.h20,
                      width: AppSizes.w20,
                    ),
                    SizedBox(width: AppSizes.w8),
                    Text(
                      'Settings',
                      style: AppStyles.black14500.copyWith(
                        fontSize: AppSizes.sp18,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SectionItemTile(
                  title: 'Account Information',
                  onTap: () {
                    context.push(AppRouter.patientAccountInfoScreen);
                  },
                ),

                ToggleTile(
                  title: 'Notifications',
                  value: notifications,
                  onChanged: _onNotificationsChanged,
                ),
                ToggleTile(
                  title: 'Early Voice Alerts',
                  value: earlyVoiceAlerts,
                  onChanged: _onEarlyVoiceAlertsChanged,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
