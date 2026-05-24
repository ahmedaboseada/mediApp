import 'package:hive_flutter/hive_flutter.dart';
import 'package:medi/core/enums/user_role.dart';
import 'package:medi/core/services/hive_box_manager.dart';
import 'package:medi/core/services/hive_service.dart';
import 'package:uuid/uuid.dart';

class HealthLogsLocalDataSource {
  static const String _boxName = 'healthLogsBox';

  final HiveBoxManager boxManager;

  HealthLogsLocalDataSource({HiveBoxManager? boxManager})
      : boxManager = boxManager ?? const HiveBoxManager();

  Future<Box<Map>> _openBox() => boxManager.openBox<Map>(_boxName);

  String _currentPrefix() {
    final role = HiveService.getUserRole();
    final user = HiveService.getUserData();
    if (role == null || user == null || user.id.isEmpty) {
      return 'anonymous';
    }
    final roleLabel = role == UserRole.doctor ? 'doctor' : 'patient';
    return '$roleLabel/${user.id}';
  }

  String _measurementKey(String type) => 'measurements/${_currentPrefix()}/$type';

  String _symptomKey() => 'symptoms/${_currentPrefix()}';

  Future<void> saveMeasurementResponse(String type, dynamic response) async {
    final box = await _openBox();
    await box.put(_measurementKey(type), _normalizeResponse(response));
  }

  dynamic getMeasurementResponse(String type) {
    if (!Hive.isBoxOpen(_boxName)) return null;
    return Hive.box<Map>(_boxName).get(_measurementKey(type));
  }

  Future<void> appendMeasurement({
    required String type,
    required Map<String, dynamic> payload,
  }) async {
    final cached = _cachedMeasurementResponse(type);
    final measurements = _extractList(cached, 'measurements');
    final entry = <String, dynamic>{
      ...payload,
      'type': payload['type'] ?? type,
      '_id': payload['_id'] ?? const Uuid().v4(),
      'date': payload['date'] ?? DateTime.now().toIso8601String(),
      'createdAt': payload['createdAt'] ?? DateTime.now().toIso8601String(),
    };

    measurements.add(entry);
    await saveMeasurementResponse(type, <String, dynamic>{'measurements': measurements});
  }

  Future<void> saveSymptomResponse(dynamic response) async {
    final box = await _openBox();
    await box.put(_symptomKey(), _normalizeResponse(response));
  }

  dynamic getSymptomResponse() {
    if (!Hive.isBoxOpen(_boxName)) return null;
    return Hive.box<Map>(_boxName).get(_symptomKey());
  }

  Future<void> appendSymptom({required Map<String, dynamic> payload}) async {
    final cached = _cachedSymptomResponse();
    final symptoms = _extractList(cached, 'symptoms');
    final entry = <String, dynamic>{
      ...payload,
      '_id': payload['_id'] ?? const Uuid().v4(),
      'date': payload['date'] ?? DateTime.now().toIso8601String(),
    };

    symptoms.add(entry);
    await saveSymptomResponse(<String, dynamic>{'symptoms': symptoms});
  }

  Future<void> clearAll() async {
    final box = await _openBox();
    await box.clear();
  }

  Map<String, dynamic> _normalizeResponse(dynamic response) {
    if (response is Map<String, dynamic>) return response;
    if (response is Map) return response.cast<String, dynamic>();
    return <String, dynamic>{};
  }

  List<Map<String, dynamic>> _extractList(dynamic response, String key) {
    final rows = response is Map<String, dynamic> ? response[key] : null;
    if (rows is List) {
      return rows
          .whereType<Map>()
          .map((e) => e.cast<String, dynamic>())
          .toList();
    }
    return <Map<String, dynamic>>[];
  }

  dynamic _cachedMeasurementResponse(String type) {
    return getMeasurementResponse(type);
  }

  dynamic _cachedSymptomResponse() {
    return getSymptomResponse();
  }
}
