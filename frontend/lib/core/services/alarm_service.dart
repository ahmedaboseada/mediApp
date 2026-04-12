import 'package:alarm/alarm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AlarmCleanupResult {
  const AlarmCleanupResult({
    required this.beforeCount,
    required this.afterCount,
    required this.removedCount,
  });

  final int beforeCount;
  final int afterCount;
  final int removedCount;
}

class AlarmService {
  const AlarmService();

  static const Duration _defaultRetentionWindow = Duration(days: 7);
  static const int _defaultMaxStopsPerRun = 180;

  Future<List<AlarmSettings>> getActiveAlarms({
    DateTime? now,
    Duration within = _defaultRetentionWindow,
  }) async {
    final reference = now ?? DateTime.now();
    final cutoff = reference.add(within);

    try {
      final all = await Alarm.getAlarms();
      return all
          .where(
            (alarm) =>
                alarm.dateTime.isAfter(reference) &&
                !alarm.dateTime.isAfter(cutoff),
          )
          .toList()
        ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    } on MissingPluginException {
      return const <AlarmSettings>[];
    } on PlatformException {
      return const <AlarmSettings>[];
    }
  }

  Future<bool> scheduleAlarm({
    required AlarmSettings settings,
    Set<int>? knownActiveIds,
    bool skipDuplicateCheck = false,
  }) async {
    try {
      final activeIds = knownActiveIds ?? await _loadActiveIdSet();
      if (!skipDuplicateCheck && activeIds.contains(settings.id)) {
        _debugLog('Alarm ${settings.id} already exists. Skip scheduling.');
        return false;
      }

      final scheduled = await Alarm.set(alarmSettings: settings);
      if (scheduled) {
        activeIds.add(settings.id);
      }
      return scheduled;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }

  Future<void> cancelAlarm(int id, {Set<int>? knownActiveIds}) async {
    try {
      await Alarm.stop(id);
      knownActiveIds?.remove(id);
    } on MissingPluginException {
      // Plugin missing on this platform; safe no-op.
    } on PlatformException {
      // Platform did not support stopping alarm; safe no-op.
    }
  }

  Future<AlarmCleanupResult> cleanupAlarms({
    DateTime? now,
    Duration retainUpcomingFor = _defaultRetentionWindow,
    int maxStops = _defaultMaxStopsPerRun,
    bool stopAllIfTooManyInvalid = false,
  }) async {
    final reference = now ?? DateTime.now();
    final keepUntil = reference.add(retainUpcomingFor);

    try {
      final alarms = await Alarm.getAlarms();
      final beforeCount = alarms.length;

      _debugLog('Alarm cleanup before: $beforeCount');

      final invalidIds = <int>[];
      for (final alarm in alarms) {
        final isPast = !alarm.dateTime.isAfter(reference);
        final isTooFar = alarm.dateTime.isAfter(keepUntil);
        if (alarm.warningNotificationOnKill || isPast || isTooFar) {
          invalidIds.add(alarm.id);
        }
      }

      if (invalidIds.isNotEmpty &&
          stopAllIfTooManyInvalid &&
          invalidIds.length > (maxStops * 2)) {
        await Alarm.stopAll();
      } else {
        for (final id in invalidIds.take(maxStops)) {
          await Alarm.stop(id);
        }
      }

      final afterCount = (await Alarm.getAlarms()).length;
      final removedCount = beforeCount - afterCount;

      _debugLog('Alarm cleanup after: $afterCount (removed: $removedCount)');

      return AlarmCleanupResult(
        beforeCount: beforeCount,
        afterCount: afterCount,
        removedCount: removedCount,
      );
    } on MissingPluginException {
      return const AlarmCleanupResult(
        beforeCount: 0,
        afterCount: 0,
        removedCount: 0,
      );
    } on PlatformException {
      return const AlarmCleanupResult(
        beforeCount: 0,
        afterCount: 0,
        removedCount: 0,
      );
    }
  }

  Future<Set<int>> _loadActiveIdSet() async {
    final alarms = await getActiveAlarms();
    return alarms.map((alarm) => alarm.id).toSet();
  }

  void _debugLog(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }
}
