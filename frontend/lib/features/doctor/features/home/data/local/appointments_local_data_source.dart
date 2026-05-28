import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:medi/core/services/hive_box_manager.dart';

class AppointmentsLocalDataSource {
  final HiveBoxManager boxManager;
  static const String _boxName = 'appointmentsBox';

  AppointmentsLocalDataSource({HiveBoxManager? boxManager}) : boxManager = boxManager ?? const HiveBoxManager();

  Future<List<Map<String, dynamic>>> getAppointmentsForDate(DateTime date) async {
    try {
      final box = await boxManager.openBox(_boxName);
      final key = DateFormat('yyyy-MM-dd').format(date);
      final raw = box.get(key);
      if (raw == null) return [];
      final list = (raw as List)
          .whereType<Map>()
          .map((e) => _deepNormalizeMap(e))
          .toList();
      log('AppointmentsLocalDataSource: loaded ${list.length} items for $key');
      return list;
    } catch (_) {
      log('AppointmentsLocalDataSource: failed to load appointments for ${date.toIso8601String()}');
      return [];
    }
  }

  Future<void> saveAppointmentsForDate(DateTime date, List<Map<String, dynamic>> items) async {
    final box = await boxManager.openBox(_boxName);
    final key = DateFormat('yyyy-MM-dd').format(date);
    final normalized = items.map((m) => _deepNormalizeMap(m)).toList();
    await box.put(key, normalized);
    log('AppointmentsLocalDataSource: saved ${normalized.length} items for $key');
  }

  Map<String, dynamic> _deepNormalizeMap(Map input) {
    final out = <String, dynamic>{};
    input.forEach((k, v) {
      final key = k?.toString() ?? '';
      out[key] = _normalizeValue(v);
    });
    return out;
  }

  dynamic _normalizeValue(dynamic v) {
    if (v is Map) {
      return _deepNormalizeMap(v);
    }
    if (v is List) {
      return v.map((e) => _normalizeValue(e)).toList();
    }
    return v;
  }
}
