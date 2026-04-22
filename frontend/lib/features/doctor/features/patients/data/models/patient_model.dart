import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

enum PatientStatus {
  normal,
  abnormal,
  critical,
  missedMeds,
}

class PatientModel {
  const PatientModel({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.bloodType,
    required this.status,
    required this.avatarAsset,
  });

  final String id;
  final String name;
  final int age;
  final String gender;
  final String bloodType;
  final PatientStatus status;
  final String avatarAsset;

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: (json['id'] ?? 'Unknown').toString(),
      name: (json['name'] ?? 'Unknown').toString(),
      age: json['age'] ?? 0,
      gender: (json['gender'] ?? 'M').toString(),
      bloodType: (json['bloodType'] ?? 'O+').toString(),
      status: _statusFromString(json['status'] ?? 'normal'),
      avatarAsset:
          (json['avatarAsset'] ?? json['avatar'] ?? AppAssets.avatar1)
              .toString(),
    );
  }

  static PatientStatus _statusFromString(String status) {
    switch (status.toLowerCase()) {
      case 'critical':
        return PatientStatus.critical;
      case 'abnormal':
        return PatientStatus.abnormal;
      case 'missedmeds':
      case 'missed_meds':
        return PatientStatus.missedMeds;
      default:
        return PatientStatus.normal;
    }
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
