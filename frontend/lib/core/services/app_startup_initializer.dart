import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medi/core/services/alarm_service.dart';
import 'package:medi/core/services/local_notification_service.dart';
import 'package:medi/core/services/connectivity_service.dart';
import 'package:medi/core/utils/service_locator.dart';
import 'package:medi/core/data/sync/sync_service.dart';
import 'package:medi/core/network/api_service.dart';
import 'package:medi/features/patient/features/add_medication/data/repo/medicine_repo.dart';
import 'package:medi/features/patient/features/health_measurements/data/repo/logs_repo.dart';
import 'package:medi/features/patient/features/doctors/data/repo/doctors_repo.dart';
import 'package:medi/core/services/hive_service.dart';

class StartupInitResult {
  const StartupInitResult({required this.errors});

  final List<String> errors;

  bool get hadFailures => errors.isNotEmpty;
}

class AppStartupInitializer {
  static const AlarmService _alarmService = AlarmService();

  static Future<StartupInitResult> initializeCoreServices() {
    return initializeCriticalServices();
  }

  static Future<StartupInitResult> initializeCriticalServices() async {
    final errors = <String>[];

    await _runSafe(
      stepName: 'Hive initialization',
      action: HiveService.init,
      errors: errors,
    );

    await _runSafe(
      stepName: 'Service locator setup',
      action: () async {
        await setupServiceLocator();
        await SyncService.init(
          apiService: getIt<ApiService>(),
          medicineRepo: getIt<MedicineRepo>(),
          logsRepo: getIt<LogsRepo>(),
          doctorsRepo: getIt<DoctorsRepository>(),
        );
        // Trigger sync on app start
        SyncService.processQueue();
      },
      errors: errors,
    );

    return StartupInitResult(errors: errors);
  }

  static Future<void> initializeDeferredServices() async {
    await _runSafe(
      stepName: 'Local notifications init',
      action: LocalNotificationService.init,
      errors: <String>[],
    );

    await _runSafe(
      stepName: 'Connectivity listener',
      action: () async => ConnectivityService.init(),
      errors: <String>[],
    );

    await _runSafe(
      stepName: 'Alarm init',
      action: () async {
        await Alarm.init();
        await _alarmService.cleanupAlarms(
          retainUpcomingFor: const Duration(days: 7),
          maxStops: 180,
          stopAllIfTooManyInvalid: true,
        );
      },
      errors: <String>[],
    );

    await _runSafe(
      stepName: 'Sync queue processing',
      action: SyncService.processQueue,
      errors: <String>[],
    );
  }

  static Future<void> _runSafe({
    required String stepName,
    required Future<void> Function() action,
    required List<String> errors,
  }) async {
    try {
      await action();
    } on MissingPluginException catch (e) {
      final message = '$stepName skipped (plugin unavailable): $e';
      debugPrint(message);
      errors.add(message);
    } on PlatformException catch (e) {
      final message =
          '$stepName failed (platform error): ${e.message ?? e.code}';
      debugPrint(message);
      errors.add(message);
    } catch (e) {
      final message = '$stepName failed: $e';
      debugPrint(message);
      errors.add(message);
    }
  }
}
