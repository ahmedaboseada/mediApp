class VerifyOtpResponse {
  final String message;
  final String resetToken;

  VerifyOtpResponse({
    required this.message,
    required this.resetToken,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      message: json['message'],
      resetToken: json['resetToken'],
    );
  }
}