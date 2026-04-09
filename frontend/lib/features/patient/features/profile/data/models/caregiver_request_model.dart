class CaregiverRequestModel {
  final String id;
  final String patientName;
  final String patientEmail;
  final DateTime? createdAt;
  final String relationship;
  final String status;

  const CaregiverRequestModel({
    required this.id,
    required this.patientName,
    required this.patientEmail,
    required this.createdAt,
    required this.relationship,
    required this.status,
  });

  factory CaregiverRequestModel.fromJson(Map<String, dynamic> json) {
    final patient = (json['patientId'] as Map<String, dynamic>?) ?? {};
    final user = (patient['userId'] as Map<String, dynamic>?) ?? {};
    final firstName = (user['firstName'] ?? '').toString().trim();
    final lastName = (user['lastName'] ?? '').toString().trim();
    final fullName = '$firstName $lastName'.trim();

    return CaregiverRequestModel(
      id: (json['_id'] ?? '').toString(),
      patientName: fullName.isEmpty ? 'Unknown Patient' : fullName,
      patientEmail: (user['email'] ?? '').toString(),
      createdAt: DateTime.tryParse((json['createdAt'] ?? '').toString()),
      relationship: (json['relationship'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
    );
  }
}
