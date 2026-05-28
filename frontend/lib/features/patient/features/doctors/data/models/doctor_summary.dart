import 'package:equatable/equatable.dart';
import 'package:medi/features/shared/auth/data/models/user_model.dart';

class Doctordata extends Equatable {
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

  const Doctordata({
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

  factory Doctordata.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> asMap(dynamic value) {
      if (value is Map<String, dynamic>) {
        return value;
      }
      if (value is Map) {
        return value.cast<String, dynamic>();
      }
      return <String, dynamic>{};
    }

    return Doctordata(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      user: UserModel.fromJson(asMap(json['userId'])),
      status: (json['status'] ?? '').toString(),
      workingDays: (json['workingDays'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      appointmentTypes: (json['appointmentTypes'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      workingHours: (json['workingHours'] as List? ?? [])
          .map(
            (e) => WorkingHour.fromJson(asMap(e)),
          )
          .toList(),
      connectedPatients: (json['connectedPatients'] as List? ?? [])
          .map(
            (e) => ConnectedPatient.fromJson(asMap(e)),
          )
          .toList(),
      clinicName: (json['clinicName'] ?? '').toString(),
      medicalLicenseId: (json['medicalLicenseId'] ?? '').toString(),
      specialization: (json['specialization'] ?? '').toString(),
      clinicAddress: (json['clinicAddress'] ?? '').toString(),
      clinicLocation: ClinicLocation.fromJson(asMap(json['clinicLocation'])),
      consultationDuration:
          int.tryParse(json['consultationDuration']?.toString() ?? '0') ?? 0,
      maxDailyPatients:
          int.tryParse(json['maxDailyPatients']?.toString() ?? '0') ?? 0,
      reviewsCount: int.tryParse(json['reviewsCount']?.toString() ?? '0') ?? 0,
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
          DateTime.now(),
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
      startHour: (json['startHour'] ?? '').toString(),
      endHour: (json['endHour'] ?? '').toString(),
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
      patientId: (json['patientId'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      id: (json['_id'] ?? json['id'] ?? '').toString(),
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
      lat: double.tryParse(json['lat']?.toString() ?? '0') ?? 0.0,
      lng: double.tryParse(json['lng']?.toString() ?? '0') ?? 0.0,
      label: (json['label'] ?? '').toString(),
    );
  }

  @override
  List<Object?> get props => [lat, lng, label];
}
