import 'package:shared_preferences/shared_preferences.dart';
import 'package:medi/core/enums/user_role.dart';

class PrefHelper {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _onboardingKey = 'onboarding_completed';
  static const String _userRoleKey = 'user_role';

  static Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  static Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, token);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  static Future<void> markOnboardingAsCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  static Future<void> markOnboardingAsNotCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, false);
  }

  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  ///
  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_accessTokenKey);
    prefs.remove(_refreshTokenKey);
  }

  /// User Role Management
  static Future<void> saveUserRole(UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userRoleKey, role.routeName);
  }

  static Future<UserRole?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final roleString = prefs.getString(_userRoleKey);
    if (roleString == null) return null;
    return roleString == 'doctor' ? UserRole.doctor : UserRole.patient;
  }

  static Future<void> clearUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_userRoleKey);
  }
}
