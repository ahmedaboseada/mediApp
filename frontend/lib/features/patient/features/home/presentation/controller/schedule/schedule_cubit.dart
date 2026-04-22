import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/add_medication/data/repo/medicine_repo.dart';

part 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  ScheduleCubit(this._medicineRepo)
    : super(
        ScheduleInitial(
          selectedDate: _dateOnly(DateTime.now()),
          mutedReminderKeys: const <String>{},
        ),
      );

  final MedicineRepo _medicineRepo;

  Future<void> loadForSelectedDate() async {
    await selectDate(state.selectedDate);
  }

  Future<void> selectDate(DateTime selectedDate) async {
    final date = _dateOnly(selectedDate);
    emit(
      ScheduleLoading(
        selectedDate: date,
        mutedReminderKeys: state.mutedReminderKeys,
      ),
    );

    final result = await _medicineRepo.getMedicationScheduleForDate(
      date: _isoDate(date),
    );

    result.fold(
      (error) {
        emit(
          ScheduleFailure(
            selectedDate: date,
            mutedReminderKeys: state.mutedReminderKeys,
            message: error.message.isEmpty
                ? 'Failed to load medication schedule'
                : error.message,
          ),
        );
      },
      (response) {
        final medications = _extractMedicationSchedule(response, date);
        emit(
          ScheduleSuccess(
            selectedDate: date,
            mutedReminderKeys: state.mutedReminderKeys,
            medications: medications,
          ),
        );
      },
    );
  }

  bool isPrimaryReminderMuted(ScheduleMedication medication) {
    final key = _reminderKey(
      medicationId: medication.id,
      date: state.selectedDate,
      time: medication.primaryTime,
    );
    return state.mutedReminderKeys.contains(key);
  }

  Future<String?> cancelPrimaryReminderNotification(
    ScheduleMedication medication,
  ) async {
    final time = medication.primaryTime.trim();
    if (time.isEmpty || time == '--:--') {
      return 'Unable to determine reminder time';
    }

    final cancelled = await LocalNotificationService()
        .cancelSingleReminderByTime(
          medicationId: medication.id,
          date: state.selectedDate,
          time: time,
          isCritical: medication.isCritical,
        );

    if (!cancelled) {
      return 'Unable to cancel this reminder time.';
    }

    final mutedKeys = Set<String>.from(state.mutedReminderKeys)
      ..add(
        _reminderKey(
          medicationId: medication.id,
          date: state.selectedDate,
          time: time,
        ),
      );
    _emitCurrentWithMutedKeys(mutedKeys);
    return null;
  }

  Future<String?> togglePrimaryReminderNotification(
    ScheduleMedication medication,
  ) async {
    final time = medication.primaryTime.trim();
    if (time.isEmpty || time == '--:--') {
      return 'Unable to determine reminder time';
    }

    final key = _reminderKey(
      medicationId: medication.id,
      date: state.selectedDate,
      time: time,
    );

    if (state.mutedReminderKeys.contains(key)) {
      final restored = await LocalNotificationService().restoreSingleReminderByTime(
        medicationId: medication.id,
        medicationName: medication.name,
        date: state.selectedDate,
        time: time,
        isCritical: medication.isCritical,
      );

      if (!restored) {
        return 'Unable to restore this reminder time.';
      }

      final mutedKeys = Set<String>.from(state.mutedReminderKeys)..remove(key);
      _emitCurrentWithMutedKeys(mutedKeys);
      return null;
    }

    return cancelPrimaryReminderNotification(medication);
  }

  Future<String?> markPrimaryTimeAsTaken(ScheduleMedication medication) async {
    final medicationId = medication.id.trim();
    final time = medication.primaryTime.trim();

    if (medicationId.isEmpty || time.isEmpty || time == '--:--') {
      return 'Unable to determine medication or time';
    }

    final result = await _medicineRepo.markAsTaken(
      medicationId: medicationId,
      date: _isoDate(state.selectedDate),
      time: time,
      taken: true,
    );

    if (result.isLeft()) {
      return result.fold(
        (error) => error.message.isEmpty
            ? 'Unable to mark medication as taken'
            : error.message,
        (_) => null,
      );
    }

    await selectDate(state.selectedDate);
    return null;
  }

  static DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  List<ScheduleMedication> _extractMedicationSchedule(
    dynamic response,
    DateTime selectedDate,
  ) {
    final rows = _scheduleRows(response);

    final medications = rows
        .map((row) {
          final id =
              (row['_id'] ??
                      row['id'] ??
                      row['medicationId'] ??
                      row['medicineId'])
                  ?.toString()
                  .trim() ??
              '';
          final name =
              (row['name'] ?? row['medicationName'])?.toString().trim() ??
              'Medication';
          final type = (row['type'] ?? '').toString().trim();
          final dosageRaw =
              (row['dosage'] ?? row['dose'] ?? row['quantity'])
                  ?.toString()
                  .trim() ??
              '';

          final times = _timesForDate(row, selectedDate);
          if (times.isEmpty) {
            return null;
          }

          return ScheduleMedication(
            id: id,
            name: name,
            type: type,
            dosage: dosageRaw.isEmpty ? '1 dose' : dosageRaw,
            isCritical:
                (row['criticalMode'] as bool?) ??
                (row['isCriticalMode'] as bool?) ??
                false,
            times: times,
          );
        })
        .whereType<ScheduleMedication>()
        .toList();

    medications.sort((left, right) {
      return _timeSortValue(
        left.primaryTime,
      ).compareTo(_timeSortValue(right.primaryTime));
    });

    return medications;
  }

  List<Map<String, dynamic>> _scheduleRows(dynamic response) {
    final scheduleRows = response is Map<String, dynamic>
        ? response['schedule'] ?? response['medications'] ?? response['data']
        : response;

    if (scheduleRows is! List) {
      return const <Map<String, dynamic>>[];
    }

    return scheduleRows.whereType<Map>().map((item) {
      return item.cast<String, dynamic>();
    }).toList();
  }

  List<ScheduleTimeItem> _timesForDate(
    Map<String, dynamic> row,
    DateTime selectedDate,
  ) {
    final timeItems = <ScheduleTimeItem>[];

    void addTimeEntry(String value, {bool taken = false}) {
      final time = value.trim();
      if (time.isEmpty) {
        return;
      }
      timeItems.add(ScheduleTimeItem(time: time, taken: taken));
    }

    void addEntriesFromList(
      List<dynamic> entries, {
      bool filterByDate = false,
    }) {
      for (final entry in entries) {
        if (entry is String) {
          addTimeEntry(entry);
          continue;
        }

        if (entry is! Map) {
          continue;
        }

        final map = entry.cast<String, dynamic>();
        if (filterByDate && !_matchesSelectedDate(map, selectedDate)) {
          continue;
        }

        final time =
            (map['time'] ?? map['at'] ?? map['value'])?.toString() ?? '';
        final taken = map['taken'] as bool? ?? false;
        addTimeEntry(time, taken: taken);
      }
    }

    final scheduleValue = row['schedule'];
    if (scheduleValue is List) {
      for (final item in scheduleValue.whereType<Map>()) {
        final map = item.cast<String, dynamic>();
        if (!_matchesSelectedDate(map, selectedDate)) {
          continue;
        }

        final nestedTimes = map['times'];
        if (nestedTimes is List) {
          addEntriesFromList(nestedTimes);
        }
        final singleTime = map['time'];
        if (singleTime is String) {
          addTimeEntry(singleTime, taken: map['taken'] as bool? ?? false);
        }
      }
    }

    final weekly = row['weekly'];
    if (weekly is List) {
      addEntriesFromList(weekly, filterByDate: true);
    }

    final times = row['times'];
    if (times is List) {
      final hasDateInfo = times.whereType<Map>().any(
        (item) =>
            item.containsKey('date') ||
            item.containsKey('day') ||
            item.containsKey('weekday'),
      );
      addEntriesFromList(times, filterByDate: hasDateInfo);
    }

    final daily = row['daily'];
    if (daily is List) {
      addEntriesFromList(daily);
    }

    final reminders = row['reminders'];
    if (reminders is List) {
      addEntriesFromList(reminders);
    }

    final unique = <String, ScheduleTimeItem>{};
    for (final item in timeItems) {
      unique[item.time] = item;
    }

    final sorted = unique.values.toList()
      ..sort(
        (left, right) =>
            _timeSortValue(left.time).compareTo(_timeSortValue(right.time)),
      );

    return sorted;
  }

  bool _matchesSelectedDate(Map<String, dynamic> value, DateTime selectedDate) {
    final dateString = (value['date'] ?? value['scheduledDate'])?.toString();
    if (dateString != null && dateString.trim().isNotEmpty) {
      final parsed = DateTime.tryParse(dateString.trim());
      if (parsed != null) {
        return _dateOnly(parsed) == _dateOnly(selectedDate);
      }
      return dateString.trim() == _isoDate(selectedDate);
    }

    final dayValue = (value['day'] ?? value['weekday'] ?? value['weekDay'])
        ?.toString();
    if (dayValue != null && dayValue.trim().isNotEmpty) {
      final normalized = dayValue.trim().toLowerCase();
      final weekdayName = _weekdayName(selectedDate).toLowerCase();
      final shortWeekday = weekdayName.substring(0, 3);
      return normalized == weekdayName || normalized == shortWeekday;
    }

    return true;
  }

  static String _isoDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  static String _weekdayName(DateTime date) {
    const days = <String>[
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    return days[date.weekday - 1];
  }

  static int _timeSortValue(String rawTime) {
    final normalized = rawTime.trim();
    if (normalized.isEmpty) {
      return 24 * 60;
    }

    final match = RegExp(
      r'^(\d{1,2})(?::(\d{2}))?\s*([AaPp][Mm])?$',
    ).firstMatch(normalized);

    if (match == null) {
      return 24 * 60;
    }

    var hour = int.tryParse(match.group(1) ?? '') ?? 0;
    final minute = int.tryParse(match.group(2) ?? '0') ?? 0;
    final period = match.group(3)?.toLowerCase();

    if (period == 'pm' && hour < 12) {
      hour += 12;
    }
    if (period == 'am' && hour == 12) {
      hour = 0;
    }

    return (hour * 60) + minute;
  }

  String _reminderKey({
    required String medicationId,
    required DateTime date,
    required String time,
  }) {
    return '${medicationId.trim()}|${_isoDate(date)}|${time.trim()}';
  }

  void _emitCurrentWithMutedKeys(Set<String> mutedKeys) {
    final selectedDate = state.selectedDate;
    if (state is ScheduleSuccess) {
      emit(
        ScheduleSuccess(
          selectedDate: selectedDate,
          mutedReminderKeys: mutedKeys,
          medications: (state as ScheduleSuccess).medications,
        ),
      );
      return;
    }

    if (state is ScheduleFailure) {
      emit(
        ScheduleFailure(
          selectedDate: selectedDate,
          mutedReminderKeys: mutedKeys,
          message: (state as ScheduleFailure).message,
        ),
      );
      return;
    }

    if (state is ScheduleLoading) {
      emit(
        ScheduleLoading(
          selectedDate: selectedDate,
          mutedReminderKeys: mutedKeys,
        ),
      );
      return;
    }

    emit(
      ScheduleInitial(selectedDate: selectedDate, mutedReminderKeys: mutedKeys),
    );
  }
}
