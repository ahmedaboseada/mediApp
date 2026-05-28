import 'package:medi/core/enums/user_role.dart';
import 'package:medi/core/services/hive_box_manager.dart';
import 'package:medi/core/services/hive_service.dart';
import 'package:uuid/uuid.dart';

class HealthLogsLocalDataSource {
  static const String _boxName = 'healthLogsBox';

  final HiveBoxManager boxManager;

  HealthLogsLocalDataSource({HiveBoxManager? boxManager})
      : boxManager = boxManager ?? const HiveBoxManager();

  Future<dynamic> _openBox() => boxManager.openBox<Map>(_boxName);

  Future<String> _currentPrefix() async {
    final role = await HiveService.getUserRole();
    final user = await HiveService.getUserData();
    final userId = (user?.id.trim().isNotEmpty ?? false)
        ? user!.id.trim()
        : await HiveService.getLastKnownUserId();
    if (role == null || userId == null || userId.isEmpty) {
      return 'anonymous';
    }
    final roleLabel = role == UserRole.doctor ? 'doctor' : 'patient';
    return '$roleLabel/$userId';
  }

  Future<String> _measurementKey(String type) async => 'measurements/${await _currentPrefix()}/$type';

  Future<String> _symptomKey() async => 'symptoms/${await _currentPrefix()}';

  Future<void> saveMeasurementResponse(String type, dynamic response) async {
    final box = await _openBox();
    await box.put(await _measurementKey(type), _normalizeResponse(response));
  }

  Future<dynamic> getMeasurementResponse(String type) async {
    final box = await _openBox();
    final currentKey = await _measurementKey(type);
    final currentValue = box.get(currentKey);
    if (currentValue != null) {
      return currentValue;
    }

    final legacyValue = box.get('measurements/$type');
    if (legacyValue != null) {
      return legacyValue;
    }

    for (final key in box.keys.whereType<String>()) {
      if (key.startsWith('measurements/') && key.endsWith('/$type')) {
        final value = box.get(key);
        if (value != null) {
          return value;
        }
      }
    }

    return null;
  }

  Future<void> appendMeasurement({
    required String type,
    required Map<String, dynamic> payload,
  }) async {
    final cached = await _cachedMeasurementResponse(type);
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
    await box.put(await _symptomKey(), _normalizeResponse(response));
  }

  Future<dynamic> getSymptomResponse() async {
    final box = await _openBox();
    final currentKey = await _symptomKey();
    final currentValue = box.get(currentKey);
    if (currentValue != null) {
      return currentValue;
    }

    final legacyValue = box.get('symptoms');
    if (legacyValue != null) {
      return legacyValue;
    }

    for (final key in box.keys.whereType<String>()) {
      if (key.startsWith('symptoms/')) {
        final value = box.get(key);
        if (value != null) {
          return value;
        }
      }
    }

    return null;
  }

  Future<void> appendSymptom({required Map<String, dynamic> payload}) async {
    final cached = await _cachedSymptomResponse();
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

  Future<dynamic> _cachedMeasurementResponse(String type) async {
    return getMeasurementResponse(type);
  }

  Future<dynamic> _cachedSymptomResponse() async {
    return getSymptomResponse();
  }
}
