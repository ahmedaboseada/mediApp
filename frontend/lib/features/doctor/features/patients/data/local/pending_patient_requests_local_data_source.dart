import 'dart:developer';

import 'package:medi/core/services/hive_box_manager.dart';

class PendingPatientRequestsLocalDataSource {
  final HiveBoxManager boxManager;
  static const String _boxName = 'pendingPatientRequests';

  PendingPatientRequestsLocalDataSource({HiveBoxManager? boxManager}) : boxManager = boxManager ?? const HiveBoxManager();

  Future<List<Map<String, dynamic>>> getPendingRequests() async {
    try {
      final box = await boxManager.openBox(_boxName);
      final raw = box.get('requests');
      if (raw == null) return [];
      final list = (raw as List).whereType<Map>().toList();
      log('PendingPatientRequests: loaded ${list.length} items');
      return List<Map<String, dynamic>>.from(list.map((e) => Map<String, dynamic>.from(e)));
    } catch (e) {
      log('PendingPatientRequests: failed to load: $e');
      return [];
    }
  }

  Future<void> addPendingRequest(Map<String, dynamic> req) async {
    final box = await boxManager.openBox(_boxName);
    final existing = await getPendingRequests();
    existing.add(req);
    await box.put('requests', existing);
    log('PendingPatientRequests: added request for ${req['patientId'] ?? req['id']}');
  }

  Future<void> removePendingRequestByPatientId(String patientId) async {
    final box = await boxManager.openBox(_boxName);
    final existing = await getPendingRequests();
    existing.removeWhere((m) => (m['patientId'] ?? m['id'])?.toString() == patientId);
    await box.put('requests', existing);
    log('PendingPatientRequests: removed requests for $patientId');
  }

  Future<void> clear() async {
    final box = await boxManager.openBox(_boxName);
    await box.delete('requests');
    log('PendingPatientRequests: cleared');
  }
}
