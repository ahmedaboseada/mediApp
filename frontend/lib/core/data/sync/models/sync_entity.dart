enum SyncEntity {
  medication,
  measurement,
  symptom,
  booking,
  profile,
  doctorSchedule,
  twoFactor,
}

extension SyncEntityX on SyncEntity {
  String get storageValue => name;

  static SyncEntity fromAny(Object? value) {
    if (value is SyncEntity) return value;
    final normalized = value?.toString().trim().toLowerCase();
    return switch (normalized) {
      'medication' => SyncEntity.medication,
      'measurement' => SyncEntity.measurement,
      'symptom' => SyncEntity.symptom,
      'booking' => SyncEntity.booking,
      'profile' => SyncEntity.profile,
      'doctorschedule' => SyncEntity.doctorSchedule,
      'doctor_schedule' => SyncEntity.doctorSchedule,
      'twofactor' => SyncEntity.twoFactor,
      'two_factor' => SyncEntity.twoFactor,
      _ => SyncEntity.medication,
    };
  }
}
