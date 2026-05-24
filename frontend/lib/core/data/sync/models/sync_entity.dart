enum SyncEntity {
  medication,
  measurement,
  symptom,
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
      _ => SyncEntity.medication,
    };
  }
}
