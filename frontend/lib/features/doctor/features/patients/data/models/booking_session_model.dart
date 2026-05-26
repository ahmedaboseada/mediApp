import 'package:medi/features/doctor/features/patients/data/models/patient_data.dart';

class BookingSessionModel {
  BookingSessionModel({
    required this.bookingId,
    required this.expiresAt,
    this.rawJson,
  });

  final String bookingId;
  final String expiresAt;
  final Map<String, dynamic>? rawJson;

  factory BookingSessionModel.fromJson(Map json) {
    return BookingSessionModel(
      bookingId: (json['bookingId'] ?? '').toString(),
      expiresAt: (json['expiresAt'] ?? '').toString(),
      rawJson: Map<String, dynamic>.from(json),
    );
  }

  PatientData? get patient {
    final patientJson = rawJson?['patient'];
    if (patientJson is Map<String, dynamic>) {
      return PatientData.fromJson(patientJson);
    }

    return null;
  }
}
