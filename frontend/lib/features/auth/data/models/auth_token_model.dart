class AuthTokensModel {
  final String accessToken;
  final String refreshToken;
  final String expiresAt;

  AuthTokensModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    return AuthTokensModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      expiresAt: json['expiresAtUtc'],
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
