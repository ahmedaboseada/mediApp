import 'package:hive_flutter/hive_flutter.dart';
import 'package:medi/core/data/sync/sync_action.dart';
import 'package:medi/core/data/sync/models/sync_action_type.dart';
import 'package:medi/core/services/app_logger.dart';
import 'package:medi/core/services/hive_box_manager.dart';

class SyncQueueManager {
  static const String boxName = 'syncBox';
  static const String _legacyListKey = 'actions';

  final HiveBoxManager boxManager;

  SyncQueueManager({HiveBoxManager? boxManager}) : boxManager = boxManager ?? const HiveBoxManager();

  Future<Box<SyncAction>> openBox() => boxManager.openBox<SyncAction>(boxName);

  Future<void> addAction(SyncAction action) async {
    final box = await openBox();
    await box.put(action.id, action);
  }

  Future<void> removeActionByKey(dynamic key) async {
    final box = await openBox();
    await box.delete(key);
  }

  Future<void> updateActionByKey(dynamic key, SyncAction action) async {
    final box = await openBox();
    await box.put(key, action);
  }

  Future<void> clear() async {
    final box = await openBox();
    await box.clear();
  }

  bool isOpen() => Hive.isBoxOpen(boxName);

  List<SyncAction> getQueuedActions() {
    if (!Hive.isBoxOpen(boxName)) return [];
    final box = Hive.box<SyncAction>(boxName);
    return box.values.whereType<SyncAction>().toList(growable: false);
  }

  Future<void> migrateLegacyActions() async {
    final box = await openBox();
    if (!box.containsKey(_legacyListKey)) return;

    final legacy = box.get(_legacyListKey);
    final legacyList = legacy as List?;
    if (legacyList != null) {
      for (final item in legacyList.whereType<Map>()) {
        try {
          final action = SyncAction.fromJson(Map<String, dynamic>.from(item));
          await box.put(action.id, action);
        } catch (e, st) {
          AppLogger.instance.w('Skipping malformed legacy sync action', e, st);
        }
      }
    }
    await box.delete(_legacyListKey);
  }

  Future<bool> optimizeQueue(SyncAction newAction) async {
    final box = await openBox();
    final pendingActions = box.values.whereType<SyncAction>().toList(growable: false);
    final entityId = newAction.data['id'] ?? newAction.data['_id'];

    if (newAction.type == SyncActionType.delete) {
      for (var index = pendingActions.length - 1; index >= 0; index--) {
        final action = pendingActions[index];
        final actionEntityId = action.data['id'] ?? action.data['_id'];
        if (action.entity == newAction.entity && actionEntityId == entityId) {
          if (action.type == SyncActionType.add) {
            await box.deleteAt(index);
            return false;
          }
          await box.deleteAt(index);
        }
      }
    } else if (newAction.type == SyncActionType.update) {
      for (var index = pendingActions.length - 1; index >= 0; index--) {
        final action = pendingActions[index];
        final actionEntityId = action.data['id'] ?? action.data['_id'];
        if (action.entity == newAction.entity && actionEntityId == entityId && action.type == SyncActionType.update) {
          await box.deleteAt(index);
        }
      }
    }

    return true;
  }

  SyncAction? firstQueuedAction() {
    if (!Hive.isBoxOpen(boxName)) return null;
    final box = Hive.box<SyncAction>(boxName);
    if (box.isEmpty) return null;
    return box.values.first;
  }

  dynamic firstKey() {
    if (!Hive.isBoxOpen(boxName)) return null;
    final box = Hive.box<SyncAction>(boxName);
    return box.isEmpty ? null : box.keys.first;
  }

  int get length {
    if (!Hive.isBoxOpen(boxName)) return 0;
    return Hive.box<SyncAction>(boxName).length;
  }
}
