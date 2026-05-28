import 'package:hive/hive.dart';
import 'package:medi/features/shared/auth/data/models/clinic_location_model.dart';
import 'package:medi/features/shared/auth/data/models/working_hours_model.dart';

part 'doctor_model.g.dart';

@HiveType(typeId: 3)
class DoctorModel {
  @HiveField(0)
  final String doctorId;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final List<String> workingDays;
  @HiveField(3)
  final List<String> appointmentTypes;
  @HiveField(4)
  final List<String> reviews;
  @HiveField(5)
  final int reviewsCount;
  @HiveField(6)
  final List<WorkingHoursModel> workingHours;
  @HiveField(7)
  final List<String> connectedPatients;
  @HiveField(8)
  final String createdAt;
  @HiveField(9)
  final String updatedAt;
  @HiveField(10)
  final String clinicName;
  @HiveField(11)
  final String medicalLicenseId;
  @HiveField(12)
  final String specialization;
  @HiveField(13)
  final String clinicAddress;
  @HiveField(14)
  final ClinicLocationModel? clinicLocation;
  @HiveField(15)
  final int consultationDuration;
  @HiveField(16)
  final int maxDailyPatients;

  DoctorModel({
    required this.doctorId,
    required this.userId,
    required this.workingDays,
    required this.appointmentTypes,
    required this.reviews,
    required this.reviewsCount,
    required this.workingHours,
    required this.connectedPatients,
    required this.createdAt,
    required this.updatedAt,
    required this.clinicName,
    required this.medicalLicenseId,
    required this.specialization,
    required this.clinicAddress,
    this.clinicLocation,
    required this.consultationDuration,
    required this.maxDailyPatients,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> asMap(dynamic v) {
      if (v is Map<String, dynamic>) return v;
      if (v is Map) return v.cast<String, dynamic>();
      return <String, dynamic>{};
    }

    return DoctorModel(
      doctorId: (json['_id'] ?? '').toString(),
      userId: (json['userId'] ?? '').toString(),
      workingDays: (json['workingDays'] as List? ?? []).map((e) => e.toString()).toList(),
      appointmentTypes: (json['appointmentTypes'] as List? ?? []).map((e) => e.toString()).toList(),
      reviews: (json['reviews'] as List? ?? []).map((item) => item.toString()).toList(),
      reviewsCount: json['reviewsCount'] as int? ?? 0,
      workingHours: (json['workingHours'] as List? ?? [])
          .map((item) => WorkingHoursModel.fromJson(asMap(item)))
          .toList(),
      connectedPatients: (json['connectedPatients'] as List? ?? []).map((item) {
        if (item is String) return item;
        if (item is Map) {
          final m = asMap(item);
          final id = m['patientId'] ?? m['_id'] ?? m['id'];
          if (id != null) return id.toString();
        }
        return item.toString();
      }).toList(),
      createdAt: (json['createdAt'] ?? '').toString(),
      updatedAt: (json['updatedAt'] ?? '').toString(),
      clinicName: (json['clinicName'] ?? '').toString(),
      medicalLicenseId: (json['medicalLicenseId'] ?? '').toString(),
      specialization: (json['specialization'] ?? '').toString(),
      clinicAddress: (json['clinicAddress'] ?? '').toString(),
      clinicLocation: json['clinicLocation'] != null
          ? ClinicLocationModel.fromJson(asMap(json['clinicLocation']))
          : null,
      consultationDuration: json['consultationDuration'] as int? ?? 0,
      maxDailyPatients: json['maxDailyPatients'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': doctorId,
      'userId': userId,
      'workingDays': workingDays,
      'appointmentTypes': appointmentTypes,
      'reviews': reviews,
      'reviewsCount': reviewsCount,
      'workingHours': workingHours.map((e) => e.toJson()).toList(),
      'connectedPatients': connectedPatients,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'clinicName': clinicName,
      'medicalLicenseId': medicalLicenseId,
      'specialization': specialization,
      'clinicAddress': clinicAddress,
      if (clinicLocation != null) 'clinicLocation': clinicLocation!.toJson(),
      'consultationDuration': consultationDuration,
      'maxDailyPatients': maxDailyPatients,
    };
  }
}
