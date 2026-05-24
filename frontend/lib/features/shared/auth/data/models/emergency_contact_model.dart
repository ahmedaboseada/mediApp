import 'package:hive/hive.dart';

class EmergencyContactModel {
  final String name;
  final String phone;
  final String? contactMethod;

  EmergencyContactModel({required this.name, required this.phone, this.contactMethod});

  factory EmergencyContactModel.fromJson(Map<String, dynamic> json) {
    return EmergencyContactModel(
      name: (json['name'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      contactMethod: json['contactMethod']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      if (contactMethod != null) 'contactMethod': contactMethod,
    };
  }
}

class EmergencyContactModelAdapter extends TypeAdapter<EmergencyContactModel> {
  @override
  final int typeId = 100;

  @override
  EmergencyContactModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return EmergencyContactModel(
      name: fields[0] as String? ?? '',
      phone: fields[1] as String? ?? '',
      contactMethod: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, EmergencyContactModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.phone)
      ..writeByte(2)
      ..write(obj.contactMethod);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmergencyContactModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
