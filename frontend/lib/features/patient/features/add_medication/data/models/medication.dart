import 'package:equatable/equatable.dart';

enum MedicationStockStatus { low, medium, good }

enum MedicationType {
  pill,
  syringe,
  bottle,
  tablet,
  cream,
  drop,
  inhaler,
  ointment,
}

class Medication extends Equatable {
  const Medication({
    this.selectedMethod = 0,
    this.name = '',
    this.type = '',
    this.dosage = '',
    this.frequency = '',
    this.startDate = '',
    this.endDate = '',
    this.reminders = const <String>[],
    this.expiryDate = '',
    this.isCriticalMode = false,
    this.schedule = '',
    this.stock = 0,
    this.stockStatus = MedicationStockStatus.good,
    // this.isCritical = false,
    this.isActive = false,
    this.isChronic = false,
    this.medicationType = MedicationType.pill,
  });

  final int selectedMethod;
  final String name;
  final String type;
  final String dosage;
  final String frequency;
  final String startDate;
  final String endDate;
  final List<String> reminders;
 // final String currentStock;
  final String schedule;
  final int stock;
  final String expiryDate;
  final bool isCriticalMode;
  final MedicationStockStatus stockStatus;
 // final bool isCritical;
  final bool isActive;
  final bool isChronic;
  final MedicationType medicationType;

  static MedicationType medicationTypeFromLabel(String? label) {
    switch (label?.trim().toLowerCase()) {
      case 'injection':
        return MedicationType.syringe;
      case 'syrup':
        return MedicationType.bottle;
      case 'tablet':
        return MedicationType.tablet;
      case 'capsule':
        return MedicationType.pill;
      case 'cream':
        return MedicationType.cream;
      case 'drop':
      case 'drops':
        return MedicationType.drop;
      case 'inhaler':
        return MedicationType.inhaler;
      case 'ointment':
        return MedicationType.ointment;
      default:
        return MedicationType.pill;
    }
  }

  MedicationType get resolvedMedicationType {
    if (medicationType == MedicationType.pill && type.isNotEmpty) {
      return medicationTypeFromLabel(type);
    }
    return medicationType;
  }

  // Backward-compatible alias used by add-medication flow screens.
  String get medicationName => name;

  Medication copyWith({
    int? selectedMethod,
    String? name,
    String? medicationName,
    String? type,
    String? dosage,
    String? frequency,
    String? startDate,
    String? endDate,
    List<String>? reminders,
    String? currentStock,
    String? schedule,
    int? stock,
    String? expiryDate,
    bool? isCriticalMode,
    MedicationStockStatus? stockStatus,
    bool? isCritical,
    bool? isActive,
    bool? isChronic,
    MedicationType? medicationType,
  }) {
    return Medication(
      selectedMethod: selectedMethod ?? this.selectedMethod,
      name: name ?? medicationName ?? this.name,
      type: type ?? this.type,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      reminders: reminders ?? this.reminders,
     // currentStock: currentStock ?? this.currentStock,
      schedule: schedule ?? this.schedule,
      stock: stock ?? this.stock,
      expiryDate: expiryDate ?? this.expiryDate,
      isCriticalMode: isCriticalMode ?? this.isCriticalMode,
      stockStatus: stockStatus ?? this.stockStatus,
      //isCritical: isCritical ?? this.isCritical,
      isActive: isActive ?? this.isActive,
      isChronic: isChronic ?? this.isChronic,
      medicationType: medicationType ?? this.medicationType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'selectedMethod': selectedMethod,
      'name': name,
      'type': type,
      'dosage': dosage,
      'frequency': frequency,
      'startDate': startDate,
      'endDate': endDate,
      'reminders': reminders,
    //  'currentStock': currentStock,
      'schedule': schedule,
      'stock': stock,
      'expiryDate': expiryDate,
      'isCriticalMode': isCriticalMode,
      'stockStatus': stockStatus.index,
      'isActive': isActive,
      'isChronic': isChronic,
      'medicationType': medicationType.index,
    };
  }

  factory Medication.fromJson(Map<dynamic, dynamic> json) {
    final medicationTypeIndex = json['medicationType'] as int?;
    final parsedType =
      medicationTypeIndex != null &&
        medicationTypeIndex >= 0 &&
        medicationTypeIndex < MedicationType.values.length
      ? MedicationType.values[medicationTypeIndex]
      : medicationTypeFromLabel(json['type'] as String?);

    return Medication(
      selectedMethod: (json['selectedMethod'] as int?) ?? 0,
      name: (json['name'] as String?) ?? '',
      type: (json['type'] as String?) ?? '',
      dosage: (json['dosage'] as String?) ?? '',
      frequency: (json['frequency'] as String?) ?? '',
      startDate: (json['startDate'] as String?) ?? '',
      endDate: (json['endDate'] as String?) ?? '',
      reminders: ((json['reminders'] as List?)?.cast<String>()) ?? [],
     // currentStock: (json['currentStock'] as String?) ?? '',
      schedule: (json['schedule'] as String?) ?? '',
      stock: (json['stock'] as int?) ?? 0,
      expiryDate: (json['expiryDate'] as String?) ?? '',
      isCriticalMode: (json['isCriticalMode'] as bool?) ?? false,
      stockStatus: MedicationStockStatus.values[(json['stockStatus'] as int?) ?? 2],
      isActive: (json['isActive'] as bool?) ?? false,
      isChronic: (json['isChronic'] as bool?) ?? false,
      medicationType: parsedType,
    );
  }

  @override
  List<Object?> get props => [
    selectedMethod,
    name,
    type,
    dosage,
    frequency,
    startDate,
    endDate,
    reminders,
   // currentStock,
    schedule,
    stock,
    expiryDate,
    isCriticalMode,
    stockStatus,
    //isCritical,
    isActive,
    isChronic,
    medicationType,
  ];
}
