import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medi/core/services/alarm_service.dart';
import 'package:medi/core/services/hive_service.dart';
import 'package:medi/core/services/local_notification_service.dart';
import 'package:medi/core/utils/service_locator.dart';

class StartupInitResult {
  const StartupInitResult({required this.errors});

  final List<String> errors;

  bool get hadFailures => errors.isNotEmpty;
}

class AppStartupInitializer {
  static const AlarmService _alarmService = AlarmService();

  static Future<StartupInitResult> initializeCoreServices() async {
    final errors = <String>[];

    await _runSafe(
      stepName: 'Hive initialization',
      action: HiveService.init,
      errors: errors,
    );

    await _runSafe(
      stepName: 'Service locator setup',
      action: setupServiceLocator,
      errors: errors,
    );

    await _runSafe(
      stepName: 'Local notifications init',
      action: LocalNotificationService.init,
      errors: errors,
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
      errors: errors,
    );

    return StartupInitResult(errors: errors);
  }

  static void initializeDeferredServices() {
    unawaited(_runDeferredServices());
  }

  static Future<void> _runDeferredServices() async {
    // Keep this method for non-critical startup work that can run later.
    await Future<void>.delayed(const Duration(milliseconds: 500));
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
      final message = '$stepName failed (platform error): ${e.message ?? e.code}';
      debugPrint(message);
      errors.add(message);
    } catch (e) {
      final message = '$stepName failed: $e';
      debugPrint(message);
      errors.add(message);
    }
  }
}