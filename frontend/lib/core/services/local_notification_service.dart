import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:medi/core/widgets/alarm_notification.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';
import 'package:medi/main.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static const String _channelId = 'medicine_reminders';
  static const String _channelName = 'Medicine Reminders';
  static const String _channelDescription =
      'Notifications to remind users to take medications on time.';

  static const String _criticalChannelId =
      'critical_medicine_reminders_alarm_v2';
  static const String _criticalChannelName = 'Critical Medicine Alerts';
  static const String _criticalChannelDescription =
      'Full-screen alerts for critical medications that require immediate attention.';

  static const String _storagePrefix = 'medicine_notification_ids_';
  static const int _maxScheduledNotifications = 500;
  static bool _isInitialized = false;

  static const AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.max,
        priority: Priority.high,
      );

  static final NotificationDetails _notificationDetails = NotificationDetails(
    android: _androidNotificationDetails,
  );

  @pragma('vm:entry-point')
  static void onTap(NotificationResponse notificationResponse) {
    // Notification tap handler.
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => AlarmScreen(
          medicineName: notificationResponse.payload ?? "Medicine",
        ),
      ),
    );
  }

  @pragma('vm:entry-point')
  static void onBackgroundTap(NotificationResponse notificationResponse) {
    // Background notification tap handler.
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => AlarmScreen(
          medicineName: notificationResponse.payload ?? "Medicine",
        ),
      ),
    );
  }

  static Future<void> init() async {
    if (_isInitialized) {
      return;
    }

    tz.initializeTimeZones();
    try {
      final timezoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezoneName));
    } catch (_) {
      // Keep default timezone if the platform timezone cannot be resolved.
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onBackgroundTap,
    );

    final androidImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidImplementation?.requestNotificationsPermission();
    await androidImplementation?.requestExactAlarmsPermission();
    await androidImplementation?.requestFullScreenIntentPermission();

    // Create notification channels
    await androidImplementation?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.max,
      ),
    );

    await androidImplementation?.createNotificationChannel(
      const AndroidNotificationChannel(
        _criticalChannelId,
        _criticalChannelName,
        description: _criticalChannelDescription,
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound('pill_shaking'),
        enableVibration: true,
        enableLights: true,
        ledColor: Color.fromARGB(255, 255, 0, 0),
        bypassDnd: true,
      ),
    );

    _isInitialized = true;
  }

  Future<void> showNotification({
    required String title,
    required String body,
    int? id,
    String? payload,
  }) async {
    await init();

    await flutterLocalNotificationsPlugin.show(
      id: id ?? DateTime.now().millisecondsSinceEpoch.remainder(2147483647),
      title: title,
      body: body,
      notificationDetails: _notificationDetails,
      payload: payload,
    );
  }

  Future<void> scheduleWithAlarmManager(
    Medication medication,
    DateTime time,
    int id,
  ) async {
    await AndroidAlarmManager.oneShotAt(
      time,
      id,
      alarmCallback,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
      params: {"name": medication.name},
    );
  }

  Future<void> scheduleMedicationReminders(Medication medication) async {
    await init();
    await cancelMedicationReminders(medication);

    final reminderTimes = _buildReminderDateTimes(
      medication,
      now: DateTime.now(),
    );
    if (reminderTimes.isEmpty) {
      return;
    }

    final storageKey = _storageKeyForMedication(medication);
    final scheduledIds = <String>[];

    for (final reminderTime in reminderTimes) {
      final id = _notificationIdFor(storageKey, reminderTime);
      scheduledIds.add(id.toString());

      // await flutterLocalNotificationsPlugin.zonedSchedule(
      //   id: id,
      //   title: medication.isCriticalMode
      //       ? '🚨 CRITICAL: ${medication.name}'
      //       : 'Medicine Reminder',
      //   body: 'It\'s time to take ${medication.name}.',
      //   scheduledDate: tz.TZDateTime.from(reminderTime, tz.local),
      //   notificationDetails: notificationDetails,
      //   payload: medication.name,
      //   androidScheduleMode: scheduleMode,
      // );
      await scheduleWithAlarmManager(medication, reminderTime, id);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(storageKey, scheduledIds);
  }

  Future<void> rescheduleMedicationReminders({
    required Medication previousMedication,
    required Medication updatedMedication,
  }) async {
    await cancelMedicationReminders(previousMedication);
    await scheduleMedicationReminders(updatedMedication);
  }

  Future<void> cancelMedicationReminders(Medication medication) async {
    await init();
    final prefs = await SharedPreferences.getInstance();
    final storageKey = _storageKeyForMedication(medication);
    final ids =
        prefs
            .getStringList(storageKey)
            ?.map(int.tryParse)
            .whereType<int>()
            .toList() ??
        const <int>[];

    for (final id in ids) {
      await flutterLocalNotificationsPlugin.cancel(id: id);
    }

    await prefs.remove(storageKey);
  }

  List<DateTime> _buildReminderDateTimes(
    Medication medication, {
    required DateTime now,
  }) {
    final reminderMinutes =
        medication.reminders
            .map(_parseMinutesSinceMidnight)
            .whereType<int>()
            .toSet()
            .toList()
          ..sort();

    if (reminderMinutes.isEmpty) {
      return const <DateTime>[];
    }

    final frequency = medication.frequency.trim().toLowerCase();
    if (frequency == 'as needed') {
      return const <DateTime>[];
    }

    final startDate =
        _parseDate(medication.startDate) ??
        DateTime(now.year, now.month, now.day);
    final parsedEndDate = _parseDate(medication.endDate);
    final fallbackEndDate = startDate.add(const Duration(days: 30));
    final endDate = (parsedEndDate ?? fallbackEndDate).isBefore(startDate)
        ? startDate
        : (parsedEndDate ?? fallbackEndDate);

    final scheduleDates = _datesByFrequency(
      frequency: frequency,
      startDate: startDate,
      endDate: endDate,
    );

    final scheduled = <DateTime>[];
    for (final date in scheduleDates) {
      for (final minute in reminderMinutes) {
        final hour = minute ~/ 60;
        final minutes = minute % 60;
        final dateTime = DateTime(
          date.year,
          date.month,
          date.day,
          hour,
          minutes,
        );

        if (dateTime.isAfter(now)) {
          scheduled.add(dateTime);
        }
      }
    }

    scheduled.sort();
    return scheduled.take(_maxScheduledNotifications).toList();
  }

  List<DateTime> _datesByFrequency({
    required String frequency,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final normalizedStart = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );
    final normalizedEnd = DateTime(endDate.year, endDate.month, endDate.day);

    if (normalizedStart.isAfter(normalizedEnd)) {
      return <DateTime>[normalizedStart];
    }

    if (frequency == 'every month') {
      final dates = <DateTime>[];
      var cursor = normalizedStart;
      while (!cursor.isAfter(normalizedEnd)) {
        dates.add(cursor);
        cursor = _addMonths(cursor, 1);
      }
      return dates;
    }

    final dayStep = switch (frequency) {
      'every 2 days' => 2,
      'every 3 days' => 3,
      'every week' => 7,
      'every 2 weeks' => 14,
      _ => 1,
    };

    final dates = <DateTime>[];
    for (
      var cursor = normalizedStart;
      !cursor.isAfter(normalizedEnd);
      cursor = cursor.add(Duration(days: dayStep))
    ) {
      dates.add(cursor);
    }

    return dates;
  }

  DateTime _addMonths(DateTime source, int monthsToAdd) {
    final rawMonth = source.month + monthsToAdd;
    final year = source.year + ((rawMonth - 1) ~/ 12);
    final month = ((rawMonth - 1) % 12) + 1;
    final maxDay = DateTime(year, month + 1, 0).day;
    final day = source.day > maxDay ? maxDay : source.day;
    return DateTime(year, month, day);
  }

  DateTime? _parseDate(String raw) {
    final value = raw.trim();
    if (value.isEmpty) {
      return null;
    }

    final iso = DateTime.tryParse(value);
    if (iso != null) {
      return DateTime(iso.year, iso.month, iso.day);
    }

    final mmddyyyy = RegExp(r'^(\d{1,2})\/(\d{1,2})\/(\d{4})$');
    final match = mmddyyyy.firstMatch(value);
    if (match == null) {
      return null;
    }

    final month = int.tryParse(match.group(1)!);
    final day = int.tryParse(match.group(2)!);
    final year = int.tryParse(match.group(3)!);
    if (month == null || day == null || year == null) {
      return null;
    }

    if (month < 1 || month > 12) {
      return null;
    }

    final maxDay = DateTime(year, month + 1, 0).day;
    if (day < 1 || day > maxDay) {
      return null;
    }

    return DateTime(year, month, day);
  }

  int? _parseMinutesSinceMidnight(String raw) {
    final value = raw.trim();
    if (value.isEmpty) {
      return null;
    }

    final twentyFourHour = RegExp(r'^([01]?\d|2[0-3]):([0-5]\d)$');
    final twentyFourHourMatch = twentyFourHour.firstMatch(value);
    if (twentyFourHourMatch != null) {
      final hour = int.parse(twentyFourHourMatch.group(1)!);
      final minute = int.parse(twentyFourHourMatch.group(2)!);
      return (hour * 60) + minute;
    }

    final twelveHour = RegExp(r'^(1[0-2]|0?[1-9]):([0-5]\d)\s*([AaPp][Mm])$');
    final twelveHourMatch = twelveHour.firstMatch(value);
    if (twelveHourMatch == null) {
      return null;
    }

    var hour = int.parse(twelveHourMatch.group(1)!);
    final minute = int.parse(twelveHourMatch.group(2)!);
    final period = twelveHourMatch.group(3)!.toLowerCase();

    if (period == 'pm' && hour != 12) {
      hour += 12;
    } else if (period == 'am' && hour == 12) {
      hour = 0;
    }

    return (hour * 60) + minute;
  }

  String _storageKeyForMedication(Medication medication) {
    final remoteId = medication.id.trim();
    if (remoteId.isNotEmpty) {
      return '$_storagePrefix$remoteId';
    }

    final fallbackIdentity = [
      medication.name,
      medication.type,
      medication.frequency,
      medication.startDate,
      medication.endDate,
      medication.reminders.join('|'),
    ].join('::');
    return '$_storagePrefix${fallbackIdentity.hashCode.abs()}';
  }

  int _notificationIdFor(String storageKey, DateTime dateTime) {
    final seed = '$storageKey|${dateTime.toIso8601String()}';
    return seed.hashCode & 0x7fffffff;
  }
}

//1.set up [initialization, permissions]=> Done.
//2.basic notification
//3. repeat notification
//4.scheduled notification

@pragma('vm:entry-point')
void alarmCallback(int id, Map<String, dynamic> params) async {
  final name = params['name'] ?? "Medicine";

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const androidDetails = AndroidNotificationDetails(
    'critical_medicine_reminders_alarm_v2',
    'Critical Medicine Alerts',
    importance: Importance.max,
    priority: Priority.max,
    fullScreenIntent: true,
    category: AndroidNotificationCategory.alarm,
    autoCancel: false,
    ongoing: true,
  );

  const details = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    id: id,
    title: '🚨 CRITICAL: $name',
    body: 'Time to take your medicine',
    notificationDetails: details,
    payload: name,
  );
}
