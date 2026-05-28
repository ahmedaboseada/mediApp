import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'app_logger.dart';

/// Generic box opener with safe-recovery from corrupted/stale data.
class HiveBoxManager {
  const HiveBoxManager();

  /// Opens a typed box or recovers it if corrupted.
  Future<Box<T>> openBox<T>(String boxName) async {
    if (Hive.isBoxOpen(boxName)) return Hive.box<T>(boxName);

    try {
      return await Hive.openBox<T>(boxName);
    } catch (e, st) {
      AppLogger.instance.e('Failed to open box $boxName', e, st);
      try {
        await Hive.deleteBoxFromDisk(boxName);
      } catch (deleteError, deleteStack) {
        AppLogger.instance.w('Failed to delete box $boxName', deleteError, deleteStack);
      }

      try {
        await _forceDeleteBoxFiles(boxName);
      } catch (forceDeleteError, forceDeleteStack) {
        AppLogger.instance.w('Failed to force-delete box $boxName files', forceDeleteError, forceDeleteStack);
      }

      // Try open again
      try {
        return await Hive.openBox<T>(boxName);
      } catch (reopenError, reopenStack) {
        AppLogger.instance.e('Failed to reopen box $boxName after cleanup', reopenError, reopenStack);
        rethrow;
      }
    }
  }

  Future<void> _forceDeleteBoxFiles(String boxName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final lowerBoxName = boxName.toLowerCase();
      final candidates = <String>[
        boxName,
        '$boxName.hive',
        '$boxName.lock',
        '$boxName.hive.lock',
        lowerBoxName,
        '$lowerBoxName.hive',
        '$lowerBoxName.lock',
        '$lowerBoxName.hive.lock',
      ];

      for (final name in candidates) {
        final file = File('${directory.path}${Platform.pathSeparator}$name');
        if (await file.exists()) {
          await file.delete();
        }
      }
    } catch (e, st) {
      if (kDebugMode) AppLogger.instance.w('Failed to force delete box files', e, st);
    }
  }
}
