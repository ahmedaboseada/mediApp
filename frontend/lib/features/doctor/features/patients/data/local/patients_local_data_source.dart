import 'dart:developer';

import 'package:medi/core/services/hive_box_manager.dart';

class PatientsLocalDataSource {
  final HiveBoxManager boxManager;
  static const String _boxName = 'patientsBox';

  PatientsLocalDataSource({HiveBoxManager? boxManager}) : boxManager = boxManager ?? const HiveBoxManager();

  Future<List<Map<String, dynamic>>> getCachedPatients() async {
    try {
      final box = await boxManager.openBox(_boxName);
      final raw = box.get('patients');
      if (raw == null) return [];
      final list = (raw as List)
          .whereType<Map>()
          .map((e) => _deepNormalizeMap(e))
          .toList();
      log('PatientsLocalDataSource: loaded ${list.length} patients');
      return list;
    } catch (e) {
      log('PatientsLocalDataSource: failed to load patients: $e');
      return [];
    }
  }

  Future<void> savePatients(List<Map<String, dynamic>> items) async {
    final box = await boxManager.openBox(_boxName);
    final normalized = items.map((m) => _deepNormalizeMap(m)).toList();
    await box.put('patients', normalized);
    log('PatientsLocalDataSource: saved ${normalized.length} patients');
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
