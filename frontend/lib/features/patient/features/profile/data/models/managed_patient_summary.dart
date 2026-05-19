class ManagedPatientSummary {
  const ManagedPatientSummary({
    required this.userId,
    required this.patientId,
    required this.name,
    required this.email,
    required this.profilePicture,
    required this.relationship,
    required this.status,
  });

  final String userId;
  final String patientId;
  final String name;
  final String email;
  final String profilePicture;
  final String relationship;
  final String status;

  factory ManagedPatientSummary.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> asMap(dynamic value) {
      if (value is Map<String, dynamic>) {
        return value;
      }

      return const {};
    }

    final user = asMap(json['user'] ?? json['userId'] ?? json['patientUser']);
    final patient = asMap(json['patient'] ?? json['patientId']);
    final nestedUser = asMap(patient['userId']);
    final resolvedUser = user.isNotEmpty ? user : nestedUser;

    final firstName = (resolvedUser['firstName'] ?? patient['firstName'] ?? '')
        .toString()
        .trim();
    final lastName = (resolvedUser['lastName'] ?? patient['lastName'] ?? '')
        .toString()
        .trim();
    final name = '$firstName $lastName'.trim();

    return ManagedPatientSummary(
      userId: (resolvedUser['id'] ?? resolvedUser['_id'] ?? json['userId'] ?? json['id'] ?? '')
        .toString(),
      patientId: (patient['_id'] ?? patient['id'] ?? json['patientId'] ?? '')
          .toString(),
      name: name.isEmpty
        ? (resolvedUser['name'] ?? patient['name'] ?? 'Unknown Patient').toString()
          : name,
      email: (resolvedUser['email'] ?? patient['email'] ?? '').toString(),
      profilePicture: (resolvedUser['profilePicture'] ?? patient['profilePicture'] ?? '')
          .toString(),
      relationship: (json['relationship'] ?? patient['relationship'] ?? '')
          .toString(),
      status: (json['status'] ?? patient['status'] ?? '').toString(),
    );
  }
}