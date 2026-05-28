import 'package:hive_flutter/hive_flutter.dart';
import 'package:medi/core/data/sync/sync_action.dart';
import 'hive_box_manager.dart';
import 'app_logger.dart';
import 'package:medi/features/shared/auth/data/models/user_model.dart';
import 'package:medi/features/shared/auth/data/models/patient_model.dart';
import 'package:medi/features/shared/auth/data/models/auth_response_model.dart';
import 'package:medi/features/shared/auth/data/models/doctor_model.dart';
import 'package:medi/features/shared/auth/data/models/working_hours_model.dart';
import 'package:medi/features/shared/auth/data/models/clinic_location_model.dart';
import 'package:medi/features/shared/auth/data/models/caregiver_model.dart';
import 'package:medi/features/shared/auth/data/models/emergency_contact_model.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';
import 'package:medi/core/data/sync/sync_service.dart';

/// Central Hive initialization moved out of the massive HiveService.
class HiveInitializer {
  final HiveBoxManager boxManager;

  HiveInitializer({HiveBoxManager? boxManager}) : boxManager = boxManager ?? const HiveBoxManager();

  Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters (keep existing ids)
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(UserModelAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(PatientModelAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(AuthResponseModelAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(DoctorModelAdapter());
    if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(WorkingHoursModelAdapter());
    if (!Hive.isAdapterRegistered(5)) Hive.registerAdapter(ClinicLocationModelAdapter());
    if (!Hive.isAdapterRegistered(6)) Hive.registerAdapter(CaregiverModelAdapter());
    if (!Hive.isAdapterRegistered(100)) Hive.registerAdapter(EmergencyContactModelAdapter());
    if (!Hive.isAdapterRegistered(7)) Hive.registerAdapter(MedicationAdapter());
    if (!Hive.isAdapterRegistered(10)) Hive.registerAdapter(SyncActionAdapter());

    try {
      await Future.wait([
        boxManager.openBox('authBox'),
        boxManager.openBox('userBox'),
        boxManager.openBox('settingsBox'),
        boxManager.openBox('medicationsBox'),
        boxManager.openBox('patientSchedulesBox'),
      ]);
      await _logStartupSnapshot();
    } catch (e, st) {
      AppLogger.instance.e('Error opening initial boxes', e, st);
    }

    // Trigger sync on app start
    try {
      SyncService.processQueue();
    } catch (e, st) {
      AppLogger.instance.w('Failed to start SyncService.processQueue', e, st);
    }
  }

  Future<void> _logStartupSnapshot() async {
    try {
      final authBox = await boxManager.openBox('authBox');
      final userBox = await boxManager.openBox('userBox');
      final settingsBox = await boxManager.openBox('settingsBox');
      final medicationsBox = await boxManager.openBox('medicationsBox');
      final schedulesBox = await boxManager.openBox('patientSchedulesBox');

      AppLogger.instance.i('Startup auth keys: ${authBox.keys.toList()}');
      AppLogger.instance.i('Startup auth values: ${authBox.toMap()}');
      AppLogger.instance.i('Startup user keys: ${userBox.keys.toList()}');
      AppLogger.instance.i('Startup user values: ${userBox.toMap()}');
      AppLogger.instance.i('Startup settings keys: ${settingsBox.keys.toList()}');
      AppLogger.instance.i('Startup medications keys: ${medicationsBox.keys.toList()}');
      AppLogger.instance.i('Startup schedules keys: ${schedulesBox.keys.toList()}');
      AppLogger.instance.i('Startup user exists: ${userBox.get('userData') != null}');
    } catch (e, st) {
      AppLogger.instance.w('Startup verification logging failed', e, st);
    }
  }
}
