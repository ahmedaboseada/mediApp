import 'package:medi/core/core.dart';

class DoctorAppointmentModel {
  const DoctorAppointmentModel({
    required this.name,
    required this.visitTime,
    required this.avatarAsset,
  });

  final String name;
  final String visitTime;
  final String avatarAsset;

  factory DoctorAppointmentModel.fromJson(Map<String, dynamic> json) {
    return DoctorAppointmentModel(
      name: (json['name'] ?? json['patientName'] ?? 'Unknown').toString(),
      visitTime: (json['visitTime'] ?? json['time'] ?? '').toString(),
      avatarAsset: (json['avatarAsset'] ?? json['avatar'] ?? AppAssets.avatar1)
          .toString(),
    );
  }
}
