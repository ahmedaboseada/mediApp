part of 'schedule_cubit.dart';

sealed class ScheduleState extends Equatable {
  const ScheduleState({required this.selectedDate});

  final DateTime selectedDate;

  @override
  List<Object?> get props => [selectedDate];
}

final class ScheduleInitial extends ScheduleState {
  const ScheduleInitial({required super.selectedDate});
}

final class ScheduleLoading extends ScheduleState {
  const ScheduleLoading({required super.selectedDate});
}

final class ScheduleSuccess extends ScheduleState {
  const ScheduleSuccess({
    required super.selectedDate,
    required this.medications,
  });

  final List<ScheduleMedication> medications;

  @override
  List<Object?> get props => [selectedDate, medications];
}

final class ScheduleFailure extends ScheduleState {
  const ScheduleFailure({required super.selectedDate, required this.message});

  final String message;

  @override
  List<Object?> get props => [selectedDate, message];
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
    return times.first.time;
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
