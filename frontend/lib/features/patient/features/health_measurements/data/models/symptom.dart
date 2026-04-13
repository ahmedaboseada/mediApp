class SymptomModel {
  const SymptomModel({
    required this.id,
    required this.allSymptoms,
    required this.severity,
    required this.notes,
    required this.date,
  });

  final String id;
  final List<String> allSymptoms;
  final String severity;
  final String notes;
  final DateTime? date;

  factory SymptomModel.fromJson(Map<String, dynamic> json) {
    final symptoms =
        (json['symptoms'] as List?)
            ?.whereType<String>()
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList() ??
        const <String>[];

    final severity = (json['severity'] as String?)?.trim().toLowerCase() ?? '';
    final notes = (json['notes'] as String?)?.trim() ?? '';
    final rawDate = (json['date'] as String?)?.trim();

    return SymptomModel(
      id: (json['_id'] as String?) ?? '',
      allSymptoms: symptoms,
      severity: severity,
      notes: notes,
      date: rawDate == null || rawDate.isEmpty
          ? null
          : DateTime.tryParse(rawDate),
    );
  }
}
