import 'package:hive_flutter/hive_flutter.dart';
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

  String _currentScheduleKey(String date) {
    final role = settingsLocal.getUserRole();
    final user = userLocal.getUserData();
    final normalizedDate = date.trim().isEmpty ? 'all' : date.trim();
    if (role != null && user != null && user.id.isNotEmpty) {
      final roleLabel = role == UserRole.doctor ? 'doctor' : 'patient';
      return 'schedule/$roleLabel/${user.id}/$normalizedDate';
    }
    return 'schedule/$normalizedDate';
  }

  Future<void> saveMedicationSchedule(String date, dynamic scheduleResponse) async {
    final box = await boxManager.openBox(_schedulesBox);
    await box.put(_currentScheduleKey(date), scheduleResponse);
  }

  dynamic getMedicationSchedule(String date) {
    if (!Hive.isBoxOpen(_schedulesBox)) return null;
    return Hive.box(_schedulesBox).get(_currentScheduleKey(date));
  }

  Future<void> markMedicationScheduleTaken({
    required String date,
    required String medicationId,
    required String time,
    required bool taken,
  }) async {
    final cached = getMedicationSchedule(date);
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
