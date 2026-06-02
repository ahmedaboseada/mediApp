class DoctorRequestModel {
  final String id;
  final String userId;
  final String fcmToken;
  final String firstName;
  final String lastName;
  final String profilePicture;
  final String clinicName;
  final String specialization;

  const DoctorRequestModel({
    required this.id,
    required this.userId,
    required this.fcmToken,
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
    required this.clinicName,
    required this.specialization,
  });

  factory DoctorRequestModel.fromJson(Map<String, dynamic> json) {
    final user = (json['userId'] as Map<String, dynamic>?) ?? {};
    return DoctorRequestModel(
      id: (json['_id'] ?? '').toString(),
      userId: (user['_id'] ?? '').toString(),
      fcmToken: (user['fcmToken'] ?? '').toString(),
      firstName: (user['firstName'] ?? '').toString(),
      lastName: (user['lastName'] ?? '').toString(),
      profilePicture: (user['profilePicture'] ?? '').toString(),
      clinicName: (json['clinicName'] ?? '').toString(),
      specialization: (json['specialization'] ?? '').toString(),
    );
  }
}
