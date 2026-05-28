import 'dart:async';

import 'package:medi/core/data/sync/models/sync_action_type.dart';
import 'package:medi/core/data/sync/models/sync_entity.dart';
import 'package:medi/core/data/sync/sync_action.dart';
import 'package:medi/core/data/sync/sync_connectivity_service.dart';
import 'package:medi/core/data/sync/sync_dispatcher.dart';
import 'package:medi/core/data/sync/sync_queue_manager.dart';
import 'package:medi/core/services/app_logger.dart';

class SyncProcessor {
  final SyncQueueManager queueManager;
  final SyncDispatcher dispatcher;
  final SyncConnectivityService connectivityService;
  final Future<void> Function(String entity, String? id) markSynced;
  final Future<void> Function(String entity, String tempId, String serverId)
      updateLocalId;
  final Future<void> Function({
    required String date,
    required String medicationId,
    required String time,
    required bool taken,
  }) markScheduleTaken;

  Completer<void>? _syncCompleter;

  SyncProcessor({
    required this.queueManager,
    required this.dispatcher,
    required this.connectivityService,
    required this.markSynced,
    required this.updateLocalId,
    required this.markScheduleTaken,
  });

  Future<void> processQueue() async {
    if (_syncCompleter != null && !_syncCompleter!.isCompleted) return;

    if (!await connectivityService.hasRealInternet()) return;

    AppLogger.instance.i('Starting sync processor');

    _syncCompleter = Completer<void>();

    try {
      await migrateLegacyActions();

      while (await queueManager.length > 0) {
        final len = await queueManager.length;
        AppLogger.instance.i('Processing sync queue, remaining=$len');

        final key = await queueManager.firstKey();
        AppLogger.instance.i('Processing sync action key: $key');

        final success = await processSingleAction(key);
        if (!success) {
          AppLogger.instance.i('Halting sync processing due to failure, key: $key');
          break;
        }
      }
    } finally {
      if (!(_syncCompleter?.isCompleted ?? true)) {
        _syncCompleter?.complete();
      }
      _syncCompleter = null;
      AppLogger.instance.i('Sync processor finished');
    }
  }

  Future<void> migrateLegacyActions() => queueManager.migrateLegacyActions();

  Future<bool> processSingleAction(dynamic key) async {
    final action = await _readActionByKey(key);
    if (action == null) {
      await queueManager.removeActionByKey(key);
      return true;
    }

    try {
      final serverResponse = await dispatcher.dispatch(action);
      if (serverResponse == null) {
        throw Exception('Empty sync response');
      }

      await handleSuccess(key: key, action: action, serverResponse: serverResponse);
      return true;
    } catch (e, st) {
      return handleFailure(key: key, action: action, error: e, stackTrace: st);
    }
  }

  Future<void> handleSuccess({
    required dynamic key,
    required SyncAction action,
    required Map<String, dynamic> serverResponse,
  }) async {
    if (action.entity == SyncEntity.medication && action.type == SyncActionType.add) {
      final tempId = (action.data['id'] ?? action.data['_id'])?.toString();
      final serverId = (serverResponse['id'] ?? serverResponse['_id'])?.toString();
      if (tempId != null && serverId != null) {
        await updateLocalId(action.entity.name, tempId, serverId);
      }
    } else if (action.entity == SyncEntity.medication && action.type == SyncActionType.markAsTaken) {
      await markScheduleTaken(
        date: action.data['date']?.toString() ?? '',
        medicationId: (action.data['id'] ?? action.data['_id'])?.toString() ?? '',
        time: action.data['time']?.toString() ?? '',
        taken: action.data['taken'] ?? true,
      );
      await markSynced(
        action.entity.name,
        (action.data['id'] ?? action.data['_id'])?.toString(),
      );
    } else {
      await markSynced(
        action.entity.name,
        (action.data['id'] ?? action.data['_id'])?.toString(),
      );
    }

    await queueManager.removeActionByKey(key);
    AppLogger.instance.i('Sync success: ${action.type.storageValue} ${action.entity.storageValue}');
  }

  Future<bool> handleFailure({
    required dynamic key,
    required SyncAction action,
    required Object error,
    required StackTrace stackTrace,
  }) async {
    AppLogger.instance.w(
      'Sync failed: ${action.type.storageValue} ${action.entity.storageValue} (retry ${action.retryCount + 1})',
      error,
      stackTrace,
    );

    action.retryCount++;
    if (action.retryCount >= 3) {
      await queueManager.removeActionByKey(key);
      AppLogger.instance.w('Dropping sync action after 3 retries: ${action.id}');
      return true;
    }

    await queueManager.updateActionByKey(key, action);
    return false;
  }

  Future<SyncAction?> _readActionByKey(dynamic key) async {
    if (!await queueManager.isOpen()) {
      await queueManager.openBox();
    }

    final box = await queueManager.openBox();
    return box.get(key);
  }
}
