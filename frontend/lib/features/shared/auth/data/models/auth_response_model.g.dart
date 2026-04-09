// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AuthResponseModelAdapter extends TypeAdapter<AuthResponseModel> {
  @override
  final int typeId = 2;

  @override
  AuthResponseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthResponseModel(
      message: fields[0] as String,
      user: fields[1] as UserModel,
      accessToken: fields[2] as String,
      refreshToken: fields[3] as String,
      doctor: fields[4] as DoctorModel?,
      patient: fields[5] as PatientModel?,
    );
  }

  @override
  void write(BinaryWriter writer, AuthResponseModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.message)
      ..writeByte(1)
      ..write(obj.user)
      ..writeByte(2)
      ..write(obj.accessToken)
      ..writeByte(3)
      ..write(obj.refreshToken)
      ..writeByte(4)
      ..write(obj.doctor)
      ..writeByte(5)
      ..write(obj.patient);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthResponseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
