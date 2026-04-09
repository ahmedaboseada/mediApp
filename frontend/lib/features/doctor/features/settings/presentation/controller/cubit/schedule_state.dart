part of 'schedule_cubit.dart';

@immutable
class ScheduleState {
  final ScheduleEntity schedule;
  const ScheduleState(this.schedule);
  ScheduleState copyWith({ScheduleEntity? schedule}) {
    return ScheduleState(schedule ?? this.schedule);
  }
}
