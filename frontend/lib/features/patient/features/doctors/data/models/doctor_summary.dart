import 'package:equatable/equatable.dart';
import 'package:medi/features/shared/auth/data/models/user_model.dart';

class DoctorModel extends Equatable {
  final String id;
  final UserModel user;
  final String status;
  final List<String> workingDays;
  final List<String> appointmentTypes;
  final List<WorkingHour> workingHours;
  final List<ConnectedPatient> connectedPatients;
  final String clinicName;
  final String medicalLicenseId;
  final String specialization;
  final String clinicAddress;
  final ClinicLocation clinicLocation;
  final int consultationDuration;
  final int maxDailyPatients;
  final int reviewsCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DoctorModel({
    required this.id,
    required this.user,
    required this.status,
    required this.workingDays,
    required this.appointmentTypes,
    required this.workingHours,
    required this.connectedPatients,
    required this.clinicName,
    required this.medicalLicenseId,
    required this.specialization,
    required this.clinicAddress,
    required this.clinicLocation,
    required this.consultationDuration,
    required this.maxDailyPatients,
    required this.reviewsCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['_id'] ?? '',
      user: UserModel.fromJson(json['userId'] ?? {}),
      status: json['status'] ?? '',
      workingDays: List<String>.from(json['workingDays'] ?? []),
      appointmentTypes: List<String>.from(json['appointmentTypes'] ?? []),
      workingHours: (json['workingHours'] as List? ?? [])
          .map((e) => WorkingHour.fromJson(e))
          .toList(),
      connectedPatients: (json['connectedPatients'] as List? ?? [])
          .map((e) => ConnectedPatient.fromJson(e))
          .toList(),
      clinicName: json['clinicName'] ?? '',
      medicalLicenseId: json['medicalLicenseId'] ?? '',
      specialization: json['specialization'] ?? '',
      clinicAddress: json['clinicAddress'] ?? '',
      clinicLocation: ClinicLocation.fromJson(json['clinicLocation'] ?? {}),
      consultationDuration: json['consultationDuration'] ?? 0,
      maxDailyPatients: json['maxDailyPatients'] ?? 0,
      reviewsCount: json['reviewsCount'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    user,
    status,
    workingDays,
    appointmentTypes,
    workingHours,
    connectedPatients,
    clinicName,
    medicalLicenseId,
    specialization,
    clinicAddress,
    clinicLocation,
    consultationDuration,
    maxDailyPatients,
    reviewsCount,
    createdAt,
    updatedAt,
  ];
}

class WorkingHour extends Equatable {
  final String startHour;
  final String endHour;

  const WorkingHour({required this.startHour, required this.endHour});

  factory WorkingHour.fromJson(Map<String, dynamic> json) {
    return WorkingHour(
      startHour: json['startHour'] ?? '',
      endHour: json['endHour'] ?? '',
    );
  }

  @override
  List<Object?> get props => [startHour, endHour];
}

class ConnectedPatient extends Equatable {
  final String patientId;
  final String status;
  final String id;

  const ConnectedPatient({
    required this.patientId,
    required this.status,
    required this.id,
  });

  factory ConnectedPatient.fromJson(Map<String, dynamic> json) {
    return ConnectedPatient(
      patientId: json['patientId'] ?? '',
      status: json['status'] ?? '',
      id: json['_id'] ?? '',
    );
  }

  @override
  List<Object?> get props => [patientId, status, id];
}

class ClinicLocation extends Equatable {
  final double lat;
  final double lng;
  final String label;

  const ClinicLocation({
    required this.lat,
    required this.lng,
    required this.label,
  });

  factory ClinicLocation.fromJson(Map<String, dynamic> json) {
    return ClinicLocation(
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
      label: json['label'] ?? '',
    );
  }

  @override
  List<Object?> get props => [lat, lng, label];
}
