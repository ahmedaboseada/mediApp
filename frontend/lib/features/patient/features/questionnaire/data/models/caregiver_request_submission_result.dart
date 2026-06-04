class CaregiverRequestSubmissionResult {
  final String message;
  final String requestId;
  final String? fcmToken;
  final String? caregiverName;
  final String? caregiverId;

  const CaregiverRequestSubmissionResult({
    required this.message,
    required this.requestId,
    this.fcmToken,
    this.caregiverName,
    this.caregiverId,
  });

  factory CaregiverRequestSubmissionResult.fromJson(
    Map<String, dynamic> json,
  ) {
    return CaregiverRequestSubmissionResult(
      message: (json['message'] ?? 'Caregiver request sent successfully')
          .toString(),
      requestId: (json['requestId'] ?? json['id'] ?? '').toString(),
      fcmToken: json['fcmToken']?.toString(),
      caregiverName: json['caregiverName']?.toString(),
      caregiverId: json['caregiverId']?.toString(),
    );
  }
}