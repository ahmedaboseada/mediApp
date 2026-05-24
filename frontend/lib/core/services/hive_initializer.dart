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

    // Open boxes used across the app. Individual data sources can open more as needed.
    try {
      await boxManager.openBox('authBox');
      await boxManager.openBox('userBox');
      await boxManager.openBox('settingsBox');
      await boxManager.openBox('medicationsBox');
      await boxManager.openBox('patientSchedulesBox');
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
}
