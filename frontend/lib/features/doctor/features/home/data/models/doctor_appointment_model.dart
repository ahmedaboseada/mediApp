import 'package:medi/core/core.dart';

class DoctorAppointmentModel {
  const DoctorAppointmentModel({
    required this.name,
    required this.visitTime,
    required this.avatarAsset,
    this.userId,
    this.patientName,
  });

  final String name;
  final String visitTime;
  final String avatarAsset;
  final String? userId;
  final String? patientName;

  factory DoctorAppointmentModel.fromJson(Map<String, dynamic> json) {
    String time = '';
    if (json['date'] != null && json['date'] is Map) {
      time = json['date']['time'] ?? '';
    } else {
      time = json['visitTime'] ?? json['time'] ?? '';
    }

    String name = '';
    String? userId;
    String? patientName;
    
    if (json['patientId'] != null && json['patientId'] is Map) {
      final patient = json['patientId'] as Map<String, dynamic>;
      
      // Extract userId
      if (patient['userId'] != null) {
        if (patient['userId'] is Map) {
          final user = patient['userId'] as Map<String, dynamic>;
          userId = (user['_id'] ?? user['id']).toString();
          name = '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}'.trim();
          patientName = name;
        } else {
          userId = patient['userId'].toString();
        }
      }
      
      // Extract patient name if not already set
      if (name.isEmpty && patient['name'] != null) {
        name = patient['name'].toString();
        patientName = name;
      }
    }

    if (name.isEmpty) {
      name = (json['name'] ?? json['patientName'] ?? '').toString();
    }

    if (name.isEmpty) {
      name = (json['bookingFor'] ?? 'Patient').toString();
      // Capitalize first letter
      if (name.isNotEmpty) {
        name = name[0].toUpperCase() + name.substring(1);
      }
    }

    return DoctorAppointmentModel(
      name: name,
      visitTime: time,
      avatarAsset: (json['avatarAsset'] ?? json['avatar'] ?? AppAssets.avatar1)
          .toString(),
      userId: userId,
      patientName: patientName ?? name,
    );
  }
}
