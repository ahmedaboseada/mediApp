import 'package:medi/core/services/hive_box_manager.dart';
import 'package:medi/core/services/hive_service.dart';
import 'package:uuid/uuid.dart';

class BookingLocalDataSource {
  static const String _boxName = 'bookingsBox';

  final HiveBoxManager boxManager;

  BookingLocalDataSource({HiveBoxManager? boxManager}) : boxManager = boxManager ?? const HiveBoxManager();

  Future<dynamic> _openBox() => boxManager.openBox<Map>(_boxName);

  Future<String> _currentKey() async {
    final role = await HiveService.getUserRole();
    final user = await HiveService.getUserData();
    final userId = (user?.id.trim().isNotEmpty ?? false)
        ? user!.id.trim()
        : await HiveService.getLastKnownUserId();
    if (role == null || userId == null || userId.isEmpty) {
      return 'bookings/anonymous';
    }
    return 'bookings/${role.name}/$userId';
  }

  Future<void> saveBookingsResponse(dynamic response) async {
    final box = await _openBox();
    await box.put(await _currentKey(), _normalizeResponse(response));
  }

  Future<dynamic> getBookingsResponse() async {
    final box = await _openBox();
    final currentKey = await _currentKey();
    final currentValue = box.get(currentKey);
    if (currentValue != null) {
      return currentValue;
    }

    final legacyValue = box.get('bookings');
    if (legacyValue != null) {
      return legacyValue;
    }

    for (final key in box.keys.whereType<String>()) {
      if (key.startsWith('bookings/')) {
        final value = box.get(key);
        if (value != null) {
          return value;
        }
      }
    }

    return null;
  }

  Future<void> appendBooking({required Map<String, dynamic> payload}) async {
    final cached = await getBookingsResponse();
    final bookings = _extractList(cached, 'bookings');
    final entry = <String, dynamic>{
      ...payload,
      '_id': payload['_id'] ?? const Uuid().v4(),
      'date': payload['date'] ?? DateTime.now().toIso8601String(),
      'createdAt': payload['createdAt'] ?? DateTime.now().toIso8601String(),
    };
    bookings.add(entry);
    await saveBookingsResponse(<String, dynamic>{'bookings': bookings});
  }

  Future<void> updateBooking({required Map<String, dynamic> payload}) async {
    final cached = await getBookingsResponse();
    final bookings = _extractList(cached, 'bookings');
    final id = (payload['id'] ?? payload['_id'])?.toString();
    if (id == null || id.isEmpty) return;
    final idx = bookings.indexWhere((b) => (b['_id'] ?? b['id'])?.toString() == id);
    if (idx >= 0) {
      bookings[idx] = {...bookings[idx], ...payload};
    } else {
      bookings.add({...payload, '_id': id, 'date': payload['date'] ?? DateTime.now().toIso8601String()});
    }
    await saveBookingsResponse(<String, dynamic>{'bookings': bookings});
  }

  Future<void> removeBooking(String id) async {
    final cached = await getBookingsResponse();
    final bookings = _extractList(cached, 'bookings');
    bookings.removeWhere((b) => (b['_id'] ?? b['id'])?.toString() == id);
    await saveBookingsResponse(<String, dynamic>{'bookings': bookings});
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
    final map = _asStringKeyedMap(response);
    final rows = map?[key];
    if (rows is List) {
      return rows.whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    }
    return <Map<String, dynamic>>[];
  }

  Map<String, dynamic>? _asStringKeyedMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return value.cast<String, dynamic>();
    return null;
  }
}
