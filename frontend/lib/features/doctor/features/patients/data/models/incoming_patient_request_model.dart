class IncomingPatientRequestModel {
  const IncomingPatientRequestModel({
    required this.patientObjectId,
    required this.name,
    required this.avatarUrl,
    required this.createdAt,
    this.fcmToken,
    this.message,
  });

  final String patientObjectId;
  final String name;
  final String avatarUrl;
  final String createdAt;
  final String? fcmToken;
  final String? message;

  factory IncomingPatientRequestModel.fromJson(Map<String, dynamic> json) {
    final patient =
        _asMap(json['patient'] ?? json['patientId'] ?? json['userId']) ??
        const <String, dynamic>{};
    final nestedUser =
        _asMap(patient['userId']) ??
        _asMap(json['user']) ??
        const <String, dynamic>{};

    final patientObjectId =
        (json['_id'] ??
                json['id'] ??
                patient['_id'] ??
                patient['id'] ??
                patient['patientId'] ??
                nestedUser['id'] ??
                '')
            .toString();
    final firstName =
        (nestedUser['firstName'] ??
                patient['firstName'] ??
                json['firstName'] ??
                '')
            .toString();
    final lastName =
        (nestedUser['lastName'] ??
                patient['lastName'] ??
                json['lastName'] ??
                '')
            .toString();
    final name = '$firstName $lastName'.trim();
    final avatarUrl =
        (nestedUser['profilePicture'] ??
                patient['profilePicture'] ??
                json['profilePicture'] ??
                '')
            .toString();
    final fcmToken =
        (nestedUser['fcmToken'] ?? patient['fcmToken'] ?? json['fcmToken'])
            ?.toString();

    return IncomingPatientRequestModel(
      patientObjectId: patientObjectId,
      name: name.isEmpty ? 'Patient' : name,
      avatarUrl: avatarUrl,
      createdAt:
          (json['createdAt'] ??
                  patient['createdAt'] ??
                  DateTime.now().toIso8601String())
              .toString(),
      fcmToken: fcmToken == null || fcmToken.trim().isEmpty
          ? null
          : fcmToken.trim(),
      message: (json['message'] ?? json['reason'] ?? json['note'])?.toString(),
    );
  }

  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }
}
