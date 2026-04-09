class AuthTokensModel {
  final String accessToken;
  final String? refreshToken;
  final String? expiresAt;

  AuthTokensModel({
    required this.accessToken,
    this.refreshToken,
    this.expiresAt,
  });

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    final payload = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return AuthTokensModel(
      accessToken: (payload['accessToken'] ?? payload['token'] ?? '')
          .toString(),
      refreshToken: payload['refreshToken']?.toString(),
      expiresAt: (payload['expiresAtUtc'] ?? payload['expiresAt'])?.toString(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAtUtc': expiresAt,
    };
  }
}
