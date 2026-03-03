class MedicationData {
  final int selectedMethod; // 0: Manual, 1: OCR, 2: Barcode
  final String medicationName;
  final String type;
  final String dosage;
  final String frequency;
  final String startDate;
  final String endDate;
  final List<String> reminders;
  final String currentStock;
  final String expiryDate;
  final bool isCriticalMode;

  const MedicationData({
    required this.selectedMethod,
    required this.medicationName,
    required this.type,
    required this.dosage,
    required this.frequency,
    required this.startDate,
    required this.endDate,
    required this.reminders,
    required this.currentStock,
    required this.expiryDate,
    required this.isCriticalMode,
  });

  // Create a copy with updated fields
  MedicationData copyWith({
    int? selectedMethod,
    String? medicationName,
    String? type,
    String? dosage,
    String? frequency,
    String? startDate,
    String? endDate,
    List<String>? reminders,
    String? currentStock,
    String? expiryDate,
    bool? isCriticalMode,
  }) {
    return MedicationData(
      selectedMethod: selectedMethod ?? this.selectedMethod,
      medicationName: medicationName ?? this.medicationName,
      type: type ?? this.type,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      reminders: reminders ?? this.reminders,
      currentStock: currentStock ?? this.currentStock,
      expiryDate: expiryDate ?? this.expiryDate,
      isCriticalMode: isCriticalMode ?? this.isCriticalMode,
    );
  }
}
