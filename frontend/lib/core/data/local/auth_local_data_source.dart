import 'package:hive_flutter/hive_flutter.dart';
import 'package:medi/core/services/hive_box_manager.dart';
import 'package:medi/features/shared/auth/data/models/auth_response_model.dart';
import 'package:medi/core/services/app_logger.dart';

class AuthLocalDataSource {
  final HiveBoxManager boxManager;
  static const String _authBox = 'authBox';
  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';
  static const String _challengeTokenKey = 'challengeToken';

  AuthLocalDataSource({HiveBoxManager? boxManager}) : boxManager = boxManager ?? const HiveBoxManager();

  Future<void> saveAccessToken(String token) async {
    try {
      final box = await boxManager.openBox(_authBox);
      await box.put(_accessTokenKey, token);
    } catch (e, st) {
      AppLogger.instance.e('saveAccessToken failed', e, st);
    }
  }

  String? getAccessToken() {
    if (!Hive.isBoxOpen(_authBox)) return null;
    return Hive.box(_authBox).get(_accessTokenKey) as String?;
  }

  Future<void> saveRefreshToken(String token) async {
    final box = await boxManager.openBox(_authBox);
    await box.put(_refreshTokenKey, token);
  }

  String? getRefreshToken() {
    if (!Hive.isBoxOpen(_authBox)) return null;
    return Hive.box(_authBox).get(_refreshTokenKey) as String?;
  }

  Future<void> saveChallengeToken(String token) async {
    final box = await boxManager.openBox(_authBox);
    await box.put(_challengeTokenKey, token);
  }

  String? getChallengeToken() {
    if (!Hive.isBoxOpen(_authBox)) return null;
    return Hive.box(_authBox).get(_challengeTokenKey) as String?;
  }

  Future<void> clearChallengeToken() async {
    final box = await boxManager.openBox(_authBox);
    await box.delete(_challengeTokenKey);
  }

  Future<void> clearTokens() async {
    final box = await boxManager.openBox(_authBox);
    await box.delete(_accessTokenKey);
    await box.delete(_refreshTokenKey);
    await box.delete(_challengeTokenKey);
  }

  Future<void> saveAuthResponse(AuthResponseModel response) async {
    try {
      final box = await boxManager.openBox(_authBox);
      await box.put('userData', response.user);
      await saveAccessToken(response.accessToken);
      await saveRefreshToken(response.refreshToken);
    } catch (e, st) {
      AppLogger.instance.e('saveAuthResponse failed', e, st);
    }
  }
}
