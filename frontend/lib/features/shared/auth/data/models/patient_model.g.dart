// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PatientModelAdapter extends TypeAdapter<PatientModel> {
  @override
  final int typeId = 1;

  @override
  PatientModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PatientModel(
      patientId: fields[0] as String,
      userId: fields[1] as String,
      chronicConditions: (fields[2] as List).cast<String>(),
      allergies: (fields[3] as List).cast<String>(),
      activeIngredients: (fields[4] as List).cast<String>(),
      longTermMedication: (fields[5] as List).cast<String>(),
      medications: (fields[6] as List).cast<String>(),
      saveOption: fields[7] as bool,
      connectedDoctors: (fields[8] as List).cast<String>(),
      createdAt: fields[9] as String,
      updatedAt: fields[10] as String,
      allergyAlerts: fields[11] as bool,
      reactionToMedication: fields[12] as bool,
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
