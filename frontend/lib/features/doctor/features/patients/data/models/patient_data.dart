import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/health_measurements/data/models/measurement_model.dart';

enum PatientStatus { normal, abnormal, critical, missedMeds }

class PatientData {
  const PatientData({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.bloodType,
    required this.status,
    required this.avatarAsset,
    required this.email,
    required this.phone,
    this.fcmToken,
    this.allergies = const [],
    this.chronicConditions = const [],
    this.medications = const [],
    this.measurements = const [],
  });

  PatientData copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    String? email,
    String? bloodType,
    PatientStatus? status,
    String? avatarAsset,
    String? phone,
    String? fcmToken,
    List<String>? allergies,
    List<String>? chronicConditions,
    List<MedicationModel>? medications,
    List<MeasurementModel>? measurements,
  }) {
    return PatientData(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      bloodType: bloodType ?? this.bloodType,
      status: status ?? this.status,
      avatarAsset: avatarAsset ?? this.avatarAsset,
      phone: phone ?? this.phone,
      fcmToken: fcmToken ?? this.fcmToken,
      allergies: allergies ?? this.allergies,
      chronicConditions: chronicConditions ?? this.chronicConditions,
      medications: medications ?? this.medications,
      measurements: measurements ?? this.measurements,
    );
  }

  final String id;
  final String name;
  final int age;
  final String gender;
  final String email;
  final String bloodType;
  final PatientStatus status;
  final String avatarAsset;
  final String phone;
  final String? fcmToken;
  final List<String> allergies;
  final List<String> chronicConditions;
  final List<MedicationModel> medications;
  final List<MeasurementModel> measurements;

  factory PatientData.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('userId') && json['userId'] is Map<String, dynamic>) {
      final user = json['userId'] as Map<String, dynamic>;
      final firstName = user['firstName'] ?? '';
      final lastName = user['lastName'] ?? '';
      final name = '$firstName $lastName'.trim();

      return PatientData(
        id: (json['_id'] ?? 'Unknown').toString(),
        name: name.isNotEmpty ? name : 'Unknown',
        age: user['age'] ?? 0,
        gender: (user['gender'] ?? 'M').toString(),
        bloodType: (user['bloodType'] ?? 'O+').toString(),
        status: _statusFromString(json['healthBadge'] ?? 'normal'),
        avatarAsset: (user['profilePicture'] ?? AppAssets.avatar1).toString(),
        phone: (user['phone'] ?? 'Unknown').toString(),
        email: (user['email'] ?? 'Unknown').toString(),
        fcmToken: _cleanToken(user['fcmToken']) ?? _cleanToken(json['fcmToken']),
        allergies: List<String>.from(json['allergies'] ?? []),
        chronicConditions: List<String>.from(json['chronicConditions'] ?? []),
        medications:
            (json['medications'] as List<dynamic>?)
                ?.where((m) => m is Map<String, dynamic>)
                .map(
                  (m) => MedicationModel.fromJson(m as Map<String, dynamic>),
                )
                .toList() ??
            [],
        measurements: _parseAndFilterMeasurements(
          json['healthMeasurements'] as List<dynamic>?,
        ),
      );
    }

    return PatientData(
      id: (json['id'] ?? json['_id'] ?? 'Unknown').toString(),
      name: (json['name'] ?? 'Unknown').toString(),
      age: json['age'] ?? 0,
      gender: (json['gender'] ?? 'M').toString(),
      bloodType: (json['bloodType'] ?? 'O+').toString(),
      status: _statusFromString(
        json['status'] ?? json['healthBadge'] ?? 'normal',
      ),
      avatarAsset:
          (json['avatarAsset'] ??
                  json['avatar'] ??
                  json['profilePicture'] ??
                  AppAssets.avatar1)
              .toString(),
      phone: (json['phone'] ?? 'Unknown').toString(),
      email: (json['email'] ?? 'Unknown').toString(),
      fcmToken: _cleanToken(json['fcmToken']) ?? _cleanToken((json['userId'] as Map<String, dynamic>?)?['fcmToken']),
      allergies: List<String>.from(json['allergies'] ?? []),
      chronicConditions: List<String>.from(json['chronicConditions'] ?? []),
      medications:
          (json['medications'] as List<dynamic>?)
              ?.where((m) => m is Map<String, dynamic>)
              .map((m) => MedicationModel.fromJson(m as Map<String, dynamic>))
              .toList() ??
          [],
      measurements: _parseAndFilterMeasurements(
        (json['healthMeasurements'] ?? json['measurements']) as List<dynamic>?,
      ),
    );
  }

  static List<MeasurementModel> _parseAndFilterMeasurements(
    List<dynamic>? measurementsJson,
  ) {
    if (measurementsJson == null || measurementsJson.isEmpty) return [];

    final list = List<Map<String, dynamic>>.from(measurementsJson);
    list.sort((a, b) {
      final dateA =
          DateTime.tryParse(a['date']?.toString() ?? '') ?? DateTime(2000);
      final dateB =
          DateTime.tryParse(b['date']?.toString() ?? '') ?? DateTime(2000);
      return dateB.compareTo(dateA); // descending
    });

    final seenTypes = <String>{};
    final latestMeasurements = <MeasurementModel>[];

    for (final m in list) {
      final type = m['type']?.toString();
      if (type != null && !seenTypes.contains(type)) {
        seenTypes.add(type);
        latestMeasurements.add(MeasurementModel.fromJson(m));
      }
    }

    return latestMeasurements;
  }

  static PatientStatus _statusFromString(String status) {
    switch (status.toLowerCase()) {
      case 'critical':
        return PatientStatus.critical;
      case 'abnormal':
        return PatientStatus.abnormal;
      case 'missedmeds':
      case 'missed_meds':
      case 'missed meds':
        return PatientStatus.missedMeds;
      default:
        return PatientStatus.normal;
    }
  }

  static String? _cleanToken(dynamic value) {
    final token = value?.toString().trim();
    if (token == null || token.isEmpty) {
      return null;
    }

    return token;
  }

  String get statusLabel {
    switch (status) {
      case PatientStatus.critical:
        return 'Critical';
      case PatientStatus.abnormal:
        return 'Abnormal';
      case PatientStatus.missedMeds:
        return 'Missed Meds';
      case PatientStatus.normal:
        return 'Normal Status';
    }
  }

  Color get statusColor {
    switch (status) {
      case PatientStatus.critical:
        return const Color(0xFFD32F2F);
      case PatientStatus.abnormal:
        return const Color(0xFFFF9800);
      case PatientStatus.missedMeds:
        return const Color(0xFFFF6B6B);
      case PatientStatus.normal:
        return const Color(0xFF4CAF50);
    }
  }
}

class MedicationModel {
  final String id;
  final String name;
  final String frequency;
  final String dosage;
  final String type;
  final int stock;
  final bool isChronic;
  final String status;

  const MedicationModel({
    required this.id,
    required this.name,
    required this.frequency,
    required this.dosage,
    required this.type,
    required this.stock,
    required this.isChronic,
    required this.status,
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      frequency: json['frequency'] ?? '',
      dosage: json['dosage']?.toString() ?? '',
      isChronic: json['isChronic'] ?? false,
      status: json['status'] ?? 'normal',
      type: json['type'] ?? 'tablet',
      stock: json['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'frequency': frequency,
      'dosage': dosage,
      'isChronic': isChronic,
      'status': status,
      'type': type,
      'stock': stock,
    };
  }
}
