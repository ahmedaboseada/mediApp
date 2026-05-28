import 'package:medi/core/services/hive_box_manager.dart';
import 'package:medi/core/services/app_logger.dart';

class NotificationLocalDataSource {
  final HiveBoxManager boxManager;
  static const String _notificationsBox = 'notificationInboxBox';

  NotificationLocalDataSource({HiveBoxManager? boxManager}) : boxManager = boxManager ?? const HiveBoxManager();

  Future<dynamic> _openBox() => boxManager.openBox(_notificationsBox);

  Future<dynamic> getInbox() async {
    final box = await _openBox();
    return box.toMap();
  }

  Future<void> saveInbox(dynamic payload) async {
    try {
      final box = await _openBox();
      await box.put('inbox', payload);
    } catch (e, st) {
      AppLogger.instance.e('saveInbox failed', e, st);
    }
  }

  Future<void> clearInbox() async {
    try {
      final box = await _openBox();
      await box.clear();
    } catch (e, st) {
      AppLogger.instance.e('clearInbox failed', e, st);
    }
  }
}
