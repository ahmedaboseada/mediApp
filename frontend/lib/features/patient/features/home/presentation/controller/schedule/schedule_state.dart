part of 'schedule_cubit.dart';

sealed class ScheduleState extends Equatable {
  const ScheduleState({
    required this.selectedDate,
    this.mutedReminderKeys = const <String>{},
  });

  final DateTime selectedDate;
  final Set<String> mutedReminderKeys;

  @override
  List<Object?> get props => [selectedDate, mutedReminderKeys];
}

final class ScheduleInitial extends ScheduleState {
  const ScheduleInitial({
    required super.selectedDate,
    super.mutedReminderKeys,
  });
}

final class ScheduleLoading extends ScheduleState {
  const ScheduleLoading({
    required super.selectedDate,
    super.mutedReminderKeys,
  });
}

final class ScheduleSuccess extends ScheduleState {
  const ScheduleSuccess({
    required super.selectedDate,
    super.mutedReminderKeys,
    required this.medications,
  });

  final List<ScheduleMedication> medications;

  @override
  List<Object?> get props => [selectedDate, medications, mutedReminderKeys];
}

final class ScheduleFailure extends ScheduleState {
  const ScheduleFailure({
    required super.selectedDate,
    super.mutedReminderKeys,
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => [selectedDate, message, mutedReminderKeys];
}

class ScheduleMedication extends Equatable {
  const ScheduleMedication({
    required this.id,
    required this.name,
    required this.type,
    required this.dosage,
    required this.isCritical,
    required this.times,
  });

  final String id;
  final String name;
  final String type;
  final String dosage;
  final bool isCritical;
  final List<ScheduleTimeItem> times;

  String get primaryTime {
    if (times.isEmpty) {
      return '--:--';
    }

    final untaken = times.where((item) => !item.taken).toList();
    if (untaken.isNotEmpty) {
      return untaken.first.time;
    }
    return times.last.time;
  }

  bool get isTaken {
    return times.every((item) => item.taken);
  }

  @override
  List<Object?> get props => [id, name, type, dosage, isCritical, times];
}

class ScheduleTimeItem extends Equatable {
  const ScheduleTimeItem({required this.time, required this.taken});

  final String time;
  final bool taken;

  @override
  List<Object?> get props => [time, taken];
}
