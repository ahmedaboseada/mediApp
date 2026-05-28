import 'package:medi/core/services/hive_box_manager.dart';
import 'package:medi/features/patient/features/doctors/data/models/doctor_summary.dart';

class DoctorsLocalDataSource {
  final HiveBoxManager boxManager;
  static const String _doctorsBox = 'doctorsBox';
  static const String _globalKey = 'globalDoctors';
  static const String _connectedKey = 'connectedDoctors';

  DoctorsLocalDataSource({HiveBoxManager? boxManager}) : boxManager = boxManager ?? const HiveBoxManager();

  Future<List<Doctordata>> getGlobalDoctors() async {
    try {
      final box = await boxManager.openBox(_doctorsBox);
      final raw = box.get(_globalKey);
      if (raw == null) return [];
      return (raw as List)
          .whereType<Map>()
          .map((e) => Doctordata.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveGlobalDoctors(List<Map<String, dynamic>> doctors) async {
    final box = await boxManager.openBox(_doctorsBox);
    await box.put(_globalKey, doctors);
  }

  Future<List<Doctordata>> getConnectedDoctors() async {
    try {
      final box = await boxManager.openBox(_doctorsBox);
      final raw = box.get(_connectedKey);
      if (raw == null) return [];
      return (raw as List)
          .whereType<Map>()
          .map((e) => Doctordata.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveConnectedDoctors(List<Map<String, dynamic>> doctors) async {
    final box = await boxManager.openBox(_doctorsBox);
    await box.put(_connectedKey, doctors);
  }
}
