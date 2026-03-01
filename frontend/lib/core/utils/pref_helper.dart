import 'package:shared_preferences/shared_preferences.dart';
import 'package:medi/core/enums/user_role.dart';

class PrefHelper {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _onboardingKey = 'onboarding_completed';
  static const String _userRoleKey = 'user_role';
  
  // User Profile Keys
  static const String _firstNameKey = 'firstName';
  static const String _lastNameKey = 'lastName';
  static const String _emailKey = 'email';
  static const String _phoneKey = 'phone';
  static const String _countryKey = 'country';
  static const String _dateOfBirthKey = 'dateOfBirth';
  static const String _genderKey = 'gender';
  static const String _profileImageKey = 'profileImage';

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

  /// User Profile Data Management
  static Future<void> saveUserProfile({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? country,
    String? dateOfBirth,
    String? gender,
    String? profileImage,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (firstName != null) await prefs.setString(_firstNameKey, firstName);
    if (lastName != null) await prefs.setString(_lastNameKey, lastName);
    if (email != null) await prefs.setString(_emailKey, email);
    if (phone != null) await prefs.setString(_phoneKey, phone);
    if (country != null) await prefs.setString(_countryKey, country);
    if (dateOfBirth != null) await prefs.setString(_dateOfBirthKey, dateOfBirth);
    if (gender != null) await prefs.setString(_genderKey, gender);
    if (profileImage != null) await prefs.setString(_profileImageKey, profileImage);
  }

  static Future<Map<String, String?>> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'firstName': prefs.getString(_firstNameKey),
      'lastName': prefs.getString(_lastNameKey),
      'email': prefs.getString(_emailKey),
      'phone': prefs.getString(_phoneKey),
      'country': prefs.getString(_countryKey),
      'dateOfBirth': prefs.getString(_dateOfBirthKey),
      'gender': prefs.getString(_genderKey),
      'profileImage': prefs.getString(_profileImageKey),
    };
  }

  static Future<String?> getFirstName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_firstNameKey);
  }

  static Future<String?> getLastName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastNameKey);
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  static Future<String?> getPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_phoneKey);
  }

  static Future<String?> getCountry() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_countryKey);
  }

  static Future<String?> getDateOfBirth() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_dateOfBirthKey);
  }

  static Future<String?> getGender() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_genderKey);
  }

  static Future<String?> getProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_profileImageKey);
  }

  static Future<void> clearUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_firstNameKey);
    await prefs.remove(_lastNameKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_phoneKey);
    await prefs.remove(_countryKey);
    await prefs.remove(_dateOfBirthKey);
    await prefs.remove(_genderKey);
    await prefs.remove(_profileImageKey);
  }

  static Future<void> clearAll() async {
    await clearTokens();
    await clearUserRole();
    await clearUserProfile();
  }
}
