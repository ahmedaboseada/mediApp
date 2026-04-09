// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    // Compatibility handling for previously shipped layouts.
    final field5 = fields[5];
    final field6 = fields[6];
    final field7 = fields[7];
    final field8 = fields[8];
    final isLegacyLayout = field5 is bool;

    return UserModel(
      id: fields[0] as String,
      type: fields[1] as String,
      firstName: fields[2] as String,
      lastName: fields[3] as String,
      email: fields[4] as String,
      twoFA: isLegacyLayout
          ? (field5 as bool? ?? false)
          : (field6 as bool? ?? false),
      profilePicture: isLegacyLayout
          ? (field6 as String? ?? '')
          : (field7 as String? ?? ''),
      confirmed: isLegacyLayout
          ? (field7 as bool? ?? false)
          : (field8 as bool? ?? false),
      gender: isLegacyLayout ? field8 as String? : field5 as String?,
      dob: fields[9] as String?,
      age: fields[10] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.firstName)
      ..writeByte(3)
      ..write(obj.lastName)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.twoFA)
      ..writeByte(6)
      ..write(obj.profilePicture)
      ..writeByte(7)
      ..write(obj.confirmed)
      ..writeByte(8)
      ..write(obj.gender)
      ..writeByte(9)
      ..write(obj.dob)
      ..writeByte(10)
      ..write(obj.age);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
