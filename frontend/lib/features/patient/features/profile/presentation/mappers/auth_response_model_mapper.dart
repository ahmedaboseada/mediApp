import 'package:medi/features/doctor/features/patients/data/models/patient_data.dart';
import 'package:medi/features/shared/auth/data/models/auth_response_model.dart';

extension AuthResponseModelMapper on AuthResponseModel {
  PatientData toPatientData() {
    final payload = rawJson ?? <String, dynamic>{};
    final userJson = Map<String, dynamic>.from(
      (payload['user'] as Map<String, dynamic>?) ?? user.toJson(),
    );
    final patientJson = Map<String, dynamic>.from(
      (payload['patient'] as Map<String, dynamic>?) ?? patient?.toJson() ?? {},
    );

    return PatientData.fromJson({
      ...patientJson,
      'userId': userJson,
      'healthMeasurements': patientJson['measurements'] ?? const <dynamic>[],
    });
  }
}
