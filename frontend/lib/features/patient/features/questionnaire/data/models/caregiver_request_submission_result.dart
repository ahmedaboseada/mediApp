class CaregiverRequestSubmissionResult {
  final String message;
  final String requestId;

  const CaregiverRequestSubmissionResult({
    required this.message,
    required this.requestId,
  });

  factory CaregiverRequestSubmissionResult.fromJson(
    Map<String, dynamic> json,
  ) {
    return CaregiverRequestSubmissionResult(
      message: (json['message'] ?? 'Caregiver request sent successfully')
          .toString(),
      requestId: (json['requestId'] ?? json['id'] ?? '').toString(),
    );
  }
}