import 'package:medi/core/services/hive_box_manager.dart';
import 'package:medi/core/services/schedule_utils.dart';
import 'package:medi/core/data/local/user_local_data_source.dart';
import 'package:medi/core/data/local/settings_local_data_source.dart';
import 'package:medi/core/enums/user_role.dart';
import 'package:medi/core/services/app_logger.dart';

class ScheduleLocalDataSource {
  final HiveBoxManager boxManager;
  final UserLocalDataSource userLocal;
  final SettingsLocalDataSource settingsLocal;

  static const String _schedulesBox = 'patientSchedulesBox';

  ScheduleLocalDataSource({
    HiveBoxManager? boxManager,
    required this.userLocal,
    required this.settingsLocal,
  }) : boxManager = boxManager ?? const HiveBoxManager();

  Future<String> _currentScheduleKey(String date) async {
    final role = await settingsLocal.getUserRole();
    final user = await userLocal.getUserData();
    final userId = (user?.id.trim().isNotEmpty ?? false)
        ? user!.id.trim()
        : await userLocal.getLastKnownUserId();
    final normalizedDate = date.trim().isEmpty ? 'all' : date.trim();
    if (role != null && userId != null && userId.isNotEmpty) {
      final roleLabel = role == UserRole.doctor ? 'doctor' : 'patient';
      return 'schedule/$roleLabel/$userId/$normalizedDate';
    }
    return 'schedule/$normalizedDate';
  }

  Future<void> saveMedicationSchedule(String date, dynamic scheduleResponse) async {
    final box = await boxManager.openBox(_schedulesBox);
    await box.put(await _currentScheduleKey(date), scheduleResponse);
  }

  Future<dynamic> getMedicationSchedule(String date) async {
    final box = await boxManager.openBox(_schedulesBox);
    final normalizedDate = date.trim().isEmpty ? 'all' : date.trim();
    final currentKey = await _currentScheduleKey(normalizedDate);
    final currentValue = box.get(currentKey);
    if (currentValue != null) {
      return currentValue;
    }

    final legacyValue = box.get('schedule/$normalizedDate');
    if (legacyValue != null) {
      return legacyValue;
    }

    for (final key in box.keys.whereType<String>()) {
      if (key.startsWith('schedule/') && key.endsWith('/$normalizedDate')) {
        final value = box.get(key);
        if (value != null) {
          return value;
        }
      }
    }

    return null;
  }

  Future<void> markMedicationScheduleTaken({
    required String date,
    required String medicationId,
    required String time,
    required bool taken,
  }) async {
    final cached = await getMedicationSchedule(date);
    if (cached == null) return;

    try {
      final updated = updateScheduleTakenState(
        cached,
        medicationId: medicationId,
        time: time,
        taken: taken,
      );
      await saveMedicationSchedule(date, updated);
    } catch (e, st) {
      AppLogger.instance.e('markMedicationScheduleTaken failed', e, st);
    }
  }
}
