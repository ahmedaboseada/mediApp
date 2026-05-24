// Utilities for traversing schedule payloads and updating taken state.
// These functions are pure so they can be unit-tested separately from Hive.

String? extractMedicationId(Map<String, dynamic> map) {
  final value = map['_id'] ?? map['id'] ?? map['medicationId'] ?? map['medicineId'];
  final id = value?.toString().trim();
  if (id == null || id.isEmpty) return null;
  return id;
}

dynamic updateScheduleTakenState(
  dynamic value, {
  required String medicationId,
  required String time,
  required bool taken,
  bool parentMatches = false,
}) {
  if (value is List) {
    return value
        .map((item) => updateScheduleTakenState(
              item,
              medicationId: medicationId,
              time: time,
              taken: taken,
              parentMatches: parentMatches,
            ))
        .toList();
  }

  if (value is! Map) return value;

  final map = Map<String, dynamic>.from(value);
  final currentId = extractMedicationId(map);
  final currentMatches = parentMatches || currentId == medicationId;

  if (currentMatches) {
    final entryTime = (map['time'] ?? map['at'] ?? map['value'])?.toString().trim();
    if (entryTime != null && entryTime == time) {
      map['taken'] = taken;
    }
  }

  for (final entry in map.entries.toList()) {
    final entryValue = entry.value;
    if (entryValue is Map || entryValue is List) {
      map[entry.key] = updateScheduleTakenState(
        entryValue,
        medicationId: medicationId,
        time: time,
        taken: taken,
        parentMatches: currentMatches,
      );
    }
  }

  return map;
}
