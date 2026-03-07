import 'package:hive/hive.dart';
import 'package:medi/features/shared/auth/data/models/doctor_model.dart';
import 'package:medi/features/shared/auth/data/models/patient_model.dart';
import 'package:medi/features/shared/auth/data/models/user_model.dart';

part 'auth_response_model.g.dart';

@HiveType(typeId: 2)
class AuthResponseModel {
  @HiveField(0)
  final String message;
  @HiveField(1)
  final UserModel user;
  @HiveField(2)
  final String accessToken;
  @HiveField(3)
  final String refreshToken;
  @HiveField(4)
  final DoctorModel? doctor;
  @HiveField(5)
  final PatientModel? patient;

  const AuthResponseModel({
    required this.message,
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    this.doctor,
    this.patient,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      message: (json['message'] ?? '').toString(),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: (json['accessToken'] ?? '').toString(),
      refreshToken: (json['refreshToken'] ?? '').toString(),
      doctor: json['doctor'] != null
          ? DoctorModel.fromJson(json['doctor'] as Map<String, dynamic>)
          : null,
      patient: json['patient'] != null
          ? PatientModel.fromJson(json['patient'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user': user.toJson(),
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      if (doctor != null) 'doctor': doctor!.toJson(),
      if (patient != null) 'patient': patient!.toJson(),
    };
  }
}
