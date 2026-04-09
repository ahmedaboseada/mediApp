// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DoctorModelAdapter extends TypeAdapter<DoctorModel> {
  @override
  final int typeId = 3;

  @override
  DoctorModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DoctorModel(
      doctorId: fields[0] as String,
      userId: fields[1] as String,
      workingDays: (fields[2] as List).cast<String>(),
      appointmentTypes: (fields[3] as List).cast<String>(),
      reviews: (fields[4] as List).cast<String>(),
      reviewsCount: fields[5] as int,
      workingHours: (fields[6] as List).cast<WorkingHoursModel>(),
      connectedPatients: (fields[7] as List).cast<String>(),
      createdAt: fields[8] as String,
      updatedAt: fields[9] as String,
      clinicName: fields[10] as String,
      medicalLicenseId: fields[11] as String,
      specialization: fields[12] as String,
      clinicAddress: fields[13] as String,
      clinicLocation: fields[14] as ClinicLocationModel?,
      consultationDuration: fields[15] as int,
      maxDailyPatients: fields[16] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DoctorModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.doctorId)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.workingDays)
      ..writeByte(3)
      ..write(obj.appointmentTypes)
      ..writeByte(4)
      ..write(obj.reviews)
      ..writeByte(5)
      ..write(obj.reviewsCount)
      ..writeByte(6)
      ..write(obj.workingHours)
      ..writeByte(7)
      ..write(obj.connectedPatients)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt)
      ..writeByte(10)
      ..write(obj.clinicName)
      ..writeByte(11)
      ..write(obj.medicalLicenseId)
      ..writeByte(12)
      ..write(obj.specialization)
      ..writeByte(13)
      ..write(obj.clinicAddress)
      ..writeByte(14)
      ..write(obj.clinicLocation)
      ..writeByte(15)
      ..write(obj.consultationDuration)
      ..writeByte(16)
      ..write(obj.maxDailyPatients);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoctorModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
