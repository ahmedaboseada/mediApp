// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clinic_location_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClinicLocationModelAdapter extends TypeAdapter<ClinicLocationModel> {
  @override
  final int typeId = 5;

  @override
  ClinicLocationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClinicLocationModel(
      lat: fields[0] as double,
      lng: fields[1] as double,
      label: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ClinicLocationModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.lat)
      ..writeByte(1)
      ..write(obj.lng)
      ..writeByte(2)
      ..write(obj.label);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClinicLocationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
