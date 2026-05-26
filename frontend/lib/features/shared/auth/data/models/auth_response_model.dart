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
  final Map<String, dynamic>? rawJson;

  const AuthResponseModel({
    required this.message,
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    this.doctor,
    this.patient,
    this.rawJson,
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
      rawJson: json,
    );
  }

  factory AuthResponseModel.fromManagedPatientAllData(
    Map<String, dynamic> json,
  ) {
    Map<String, dynamic> asMap(dynamic value) {
      if (value is Map<String, dynamic>) {
        return value;
      }

      return const {};
    }

    final patientJson = asMap(json['patient'] ?? json['patientId']);
    final nestedUserJson = asMap(patientJson['userId']);
    final userJson = asMap(json['user'] ?? json['userId']);
    final resolvedUserJson = userJson.isNotEmpty ? userJson : nestedUserJson;
    final medicinesJson = json['medicines'] ?? json['medications'];

    final mergedPatientJson = <String, dynamic>{
      ...patientJson,
      if (medicinesJson is List) 'medications': medicinesJson,
    };

    return AuthResponseModel(
      message: (json['message'] ?? 'Managed patient data loaded').toString(),
      user: UserModel.fromJson(resolvedUserJson),
      accessToken: '',
      refreshToken: '',
      patient: mergedPatientJson.isNotEmpty
          ? PatientModel.fromJson(mergedPatientJson)
          : null,
      rawJson: json,
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
