// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'caregiver_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CaregiverModelAdapter extends TypeAdapter<CaregiverModel> {
  @override
  final int typeId = 6;

  @override
  CaregiverModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CaregiverModel(
      giving: (fields[0] as List).cast<String>(),
      caregivingOption: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CaregiverModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.giving)
      ..writeByte(1)
      ..write(obj.caregivingOption);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CaregiverModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
