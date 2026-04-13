import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

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
    this.id = '',
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
    this.sideEffects = const <String>[],
  });

  final String id;
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
  final List<String> sideEffects;

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
    String? id,
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
    List<String>? sideEffects,
  }) {
    return Medication(
      id: id ?? this.id,
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
      sideEffects: sideEffects ?? this.sideEffects,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
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
      'sideEffects': sideEffects,
    };
  }

  factory Medication.fromJson(Map<dynamic, dynamic> json) {
    final medicationTypeIndex = json['medicationType'] as int?;
    final status = (json['status'] as String?)?.trim().toLowerCase();
    final leftThreshold = (json['leftThreshold'] as num?)?.toInt() ?? 10;
    final stockValue = (json['stock'] as num?)?.toInt() ?? 0;
    final parsedType =
        medicationTypeIndex != null &&
            medicationTypeIndex >= 0 &&
            medicationTypeIndex < MedicationType.values.length
        ? MedicationType.values[medicationTypeIndex]
        : medicationTypeFromLabel(json['type'] as String?);

    final parsedReminders =
        ((json['daily'] as List?) ?? (json['reminders'] as List?) ?? const [])
            .whereType<String>()
            .toList();

    final parsedStockStatus = stockValue <= leftThreshold
        ? MedicationStockStatus.low
        : (stockValue <= leftThreshold * 2
              ? MedicationStockStatus.medium
              : MedicationStockStatus.good);

    return Medication(
      id: (json['_id'] as String?) ?? (json['id'] as String?) ?? '',
      selectedMethod: (json['selectedMethod'] as int?) ?? 0,
      name: (json['name'] as String?) ?? '',
      type: (json['type'] as String?) ?? '',
      dosage: (json['dosage'] as String?) ?? '',
      frequency: (json['frequency'] as String?) ?? '',
      startDate: (json['startDate'] as String?) ?? '',
      endDate: (json['endDate'] as String?) ?? '',
      reminders: parsedReminders,
      // currentStock: (json['currentStock'] as String?) ?? '',
      schedule: (json['schedule'] as String?) ?? '',
      stock: stockValue,
      expiryDate: (json['expiryDate'] as String?) ?? '',
      isCriticalMode:
          (json['criticalMode'] as bool?) ??
          (json['isCriticalMode'] as bool?) ??
          false,
      stockStatus: (json['stockStatus'] is int)
          ? MedicationStockStatus.values[(json['stockStatus'] as int).clamp(
              0,
              MedicationStockStatus.values.length - 1,
            )]
          : parsedStockStatus,
      isActive:
          (json['isActive'] as bool?) ??
          (status == null ? false : status != 'inactive'),
      isChronic: (json['isChronic'] as bool?) ?? false,
      medicationType: parsedType,
      sideEffects:
          (json['sideEffects'] as List?)?.whereType<String>().toList() ??
          const <String>[],
    );
  }

  @override
  List<Object?> get props => [
    id,
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
    sideEffects,
  ];
}

class MedicationScheduleTime extends Equatable {
  const MedicationScheduleTime({required this.time, required this.taken});

  final String time;
  final bool taken;

  MedicationScheduleTime copyWith({String? time, bool? taken}) {
    return MedicationScheduleTime(
      time: time ?? this.time,
      taken: taken ?? this.taken,
    );
  }

  @override
  List<Object?> get props => [time, taken];
}

class MedicationAdapter extends TypeAdapter<Medication> {
  @override
  final int typeId = 7;

  @override
  Medication read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    final medicationTypeIndex = fields[15] as int?;
    final parsedType =
        medicationTypeIndex != null &&
            medicationTypeIndex >= 0 &&
            medicationTypeIndex < MedicationType.values.length
        ? MedicationType.values[medicationTypeIndex]
        : Medication.medicationTypeFromLabel(fields[2] as String?);

    return Medication(
      id: fields[16] as String? ?? '',
      selectedMethod: fields[0] as int? ?? 0,
      name: fields[1] as String? ?? '',
      type: fields[2] as String? ?? '',
      dosage: fields[3] as String? ?? '',
      frequency: fields[4] as String? ?? '',
      startDate: fields[5] as String? ?? '',
      endDate: fields[6] as String? ?? '',
      reminders: (fields[7] as List?)?.cast<String>() ?? const <String>[],
      schedule: fields[8] as String? ?? '',
      stock: fields[9] as int? ?? 0,
      expiryDate: fields[10] as String? ?? '',
      isCriticalMode: fields[11] as bool? ?? false,
      stockStatus: MedicationStockStatus
          .values[(fields[12] as int?) ?? MedicationStockStatus.good.index],
      isActive: fields[13] as bool? ?? false,
      isChronic: fields[14] as bool? ?? false,
      medicationType: parsedType,
      sideEffects: (fields[17] as List?)?.cast<String>() ?? const <String>[],
    );
  }

  @override
  void write(BinaryWriter writer, Medication obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.selectedMethod)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.dosage)
      ..writeByte(4)
      ..write(obj.frequency)
      ..writeByte(5)
      ..write(obj.startDate)
      ..writeByte(6)
      ..write(obj.endDate)
      ..writeByte(7)
      ..write(obj.reminders)
      ..writeByte(8)
      ..write(obj.schedule)
      ..writeByte(9)
      ..write(obj.stock)
      ..writeByte(10)
      ..write(obj.expiryDate)
      ..writeByte(11)
      ..write(obj.isCriticalMode)
      ..writeByte(12)
      ..write(obj.stockStatus.index)
      ..writeByte(13)
      ..write(obj.isActive)
      ..writeByte(14)
      ..write(obj.isChronic)
      ..writeByte(15)
      ..write(obj.medicationType.index)
      ..writeByte(16)
      ..write(obj.id)
      ..writeByte(17)
      ..write(obj.sideEffects);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
