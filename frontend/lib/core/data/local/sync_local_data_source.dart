import 'package:hive_flutter/hive_flutter.dart';
import 'package:medi/core/services/hive_box_manager.dart';
import 'package:medi/core/data/sync/sync_action.dart';
import 'package:medi/core/services/app_logger.dart';

class SyncLocalDataSource {
  final HiveBoxManager boxManager;
  static const String _syncBox = 'syncBox';

  SyncLocalDataSource({HiveBoxManager? boxManager}) : boxManager = boxManager ?? const HiveBoxManager();

  Future<Box<SyncAction>> _open() => boxManager.openBox<SyncAction>(_syncBox);

  Future<void> addAction(SyncAction action) async {
    try {
      final box = await _open();
      await box.add(action);
    } catch (e, st) {
      AppLogger.instance.e('addAction failed', e, st);
    }
  }

  Future<List<SyncAction>> getQueue() async {
    try {
      final box = await _open();
      return box.values.toList();
    } catch (e, st) {
      AppLogger.instance.e('getQueue failed', e, st);
      return [];
    }
  }

  Future<void> clearQueue() async {
    try {
      final box = await _open();
      await box.clear();
    } catch (e, st) {
      AppLogger.instance.e('clearQueue failed', e, st);
    }
  }
}
