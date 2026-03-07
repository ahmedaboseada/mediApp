// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'working_hours_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkingHoursModelAdapter extends TypeAdapter<WorkingHoursModel> {
  @override
  final int typeId = 4;

  @override
  WorkingHoursModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkingHoursModel(
      startHour: fields[0] as String,
      endHour: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WorkingHoursModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.startHour)
      ..writeByte(1)
      ..write(obj.endHour);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkingHoursModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
