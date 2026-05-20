// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PatientModelAdapter extends TypeAdapter<PatientModel> {
  @override
  final int typeId = 1;

  List<T> _readList<T>(dynamic value) {
    if (value is List) {
      return value.whereType<T>().toList();
    }

    if (value == null) {
      return <T>[];
    }

    if (value is T) {
      return <T>[value];
    }

    return <T>[];
  }

  @override
  PatientModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PatientModel(
      patientId: fields[0] as String? ?? '',
      userId: fields[1] as String? ?? '',
      chronicConditions: _readList<String>(fields[2]),
      allergies: _readList<String>(fields[3]),
      activeIngredients: _readList<String>(fields[4]),
      longTermMedication: _readList<String>(fields[5]),
      medications: _readList<Medication>(fields[6]),
      saveOption: fields[7] as bool? ?? false,
      connectedDoctors: _readList<String>(fields[8]),
      createdAt: fields[9] as String? ?? '',
      updatedAt: fields[10] as String? ?? '',
      allergyAlerts: fields[11] as bool? ?? false,
      reactionToMedication: fields[12] as bool? ?? false,
      caregiver: fields[13] as CaregiverModel?,
    );
  }

  @override
  void write(BinaryWriter writer, PatientModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.patientId)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.chronicConditions)
      ..writeByte(3)
      ..write(obj.allergies)
      ..writeByte(4)
      ..write(obj.activeIngredients)
      ..writeByte(5)
      ..write(obj.longTermMedication)
      ..writeByte(6)
      ..write(obj.medications)
      ..writeByte(7)
      ..write(obj.saveOption)
      ..writeByte(8)
      ..write(obj.connectedDoctors)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.allergyAlerts)
      ..writeByte(12)
      ..write(obj.reactionToMedication)
      ..writeByte(13)
      ..write(obj.caregiver);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatientModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
