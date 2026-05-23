import 'package:hive_flutter/hive_flutter.dart';
import 'package:medi/core/services/hive_service.dart';
import 'package:medi/features/patient/features/notification/presentation/models/notification_item.dart';

class NotificationInboxService {
  NotificationInboxService._();

  static const String boxName = 'notificationInboxBox';
  static const String notificationsKey = 'notifications';

  static Future<Box> openBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox(boxName);
    }
    return Hive.box(boxName);
  }

  static Future<void> ensureReady() async {
    await openBox();
  }

  static Future<List<NotificationInboxItem>> getNotifications() async {
    final box = await openBox();
    final raw = box.get(notificationsKey, defaultValue: <dynamic>[]);
    if (raw is! List) {
      return const <NotificationInboxItem>[];
    }

    final items = raw
        .whereType<Map>()
        .map((entry) => NotificationInboxItem.fromMap(Map<String, dynamic>.from(entry)))
        .toList(growable: false);

    items.sort((left, right) => right.createdAt.compareTo(left.createdAt));
    return items;
  }

  static Future<void> recordNotification(NotificationInboxItem item) async {
    final box = await openBox();
    final current = <NotificationInboxItem>[
      item,
      ...await getNotifications(),
    ];
    await box.put(
      notificationsKey,
      current.map((entry) => entry.toMap()).toList(growable: false),
    );

    if (!item.isRead) {
      await HiveService.incrementUnreadNotificationsCount();
    }
  }

  static Future<void> markAllAsRead() async {
    final items = await getNotifications();
    final updated = items.map((item) => item.copyWith(isRead: true)).toList(growable: false);
    final box = await openBox();
    await box.put(
      notificationsKey,
      updated.map((entry) => entry.toMap()).toList(growable: false),
    );
    await HiveService.markNotificationsAsRead();
  }

  static Future<void> clear() async {
    final box = await openBox();
    await box.clear();
  }

  static NotificationCategory categoryFromMessageData(Map<String, dynamic> data) {
    final value = (data['category'] ?? data['eventType'] ?? '').toString().toLowerCase();
    if (value.contains('health') || value.contains('symptom')) {
      return NotificationCategory.health;
    }
    if (value.contains('doctor') || value.contains('caregiver') || value.contains('request')) {
      return NotificationCategory.doctor;
    }
    return NotificationCategory.medication;
  }
}