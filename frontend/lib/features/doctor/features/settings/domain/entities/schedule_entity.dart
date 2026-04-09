class ScheduleEntity {
  final List<String> workingDays;
  final String? startTime;
  final String? endTime;
  final String? consultationDuration;
  final List<String> appointmentTypes;
  final int? maxPatients;

  ScheduleEntity({
    required this.workingDays,
    this.startTime,
    this.endTime,
    this.consultationDuration,
    required this.appointmentTypes,
    this.maxPatients,
  });
  ScheduleEntity copyWith({
    List<String>? workingDays,
    String? startTime,
    String? endTime,
    String? consultationDuration,
    List<String>? appointmentTypes,
    int? maxPatients,
  }) {
    return ScheduleEntity(
      workingDays: workingDays ?? this.workingDays,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      consultationDuration: consultationDuration ?? this.consultationDuration,
      appointmentTypes: appointmentTypes ?? this.appointmentTypes,
      maxPatients: maxPatients ?? this.maxPatients,
    );
  }
}
