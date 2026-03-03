import 'package:medi/features/shared/auth/data/models/user_model.dart';
import 'package:medi/features/shared/auth/data/models/patient_model.dart';

class RegisterResponse {
  final String message;
  final UserModel user;
  final String accessToken;
  final String refreshToken;
  final PatientModel patient;

  RegisterResponse({
    required this.message,
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.patient,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      message: json['message'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      patient: PatientModel.fromJson(json['patient'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user': user.toJson(),
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'patient': patient.toJson(),
    };
  }
}
