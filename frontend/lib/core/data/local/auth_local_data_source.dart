import 'package:medi/core/services/hive_box_manager.dart';
import 'package:medi/features/shared/auth/data/models/auth_response_model.dart';
import 'package:medi/features/shared/auth/data/models/user_model.dart';
import 'package:medi/features/shared/auth/data/models/patient_model.dart';
import 'package:medi/features/shared/auth/data/models/doctor_model.dart';
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

  Future<String?> getAccessToken() async {
    try {
      final box = await boxManager.openBox(_authBox);
      return box.get(_accessTokenKey) as String?;
    } catch (e, st) {
      AppLogger.instance.e('getAccessToken failed', e, st);
      return null;
    }
  }

  Future<void> saveRefreshToken(String token) async {
    final box = await boxManager.openBox(_authBox);
    await box.put(_refreshTokenKey, token);
  }

  Future<String?> getRefreshToken() async {
    try {
      final box = await boxManager.openBox(_authBox);
      return box.get(_refreshTokenKey) as String?;
    } catch (e, st) {
      AppLogger.instance.e('getRefreshToken failed', e, st);
      return null;
    }
  }

  Future<void> saveChallengeToken(String token) async {
    final box = await boxManager.openBox(_authBox);
    await box.put(_challengeTokenKey, token);
  }

  Future<String?> getChallengeToken() async {
    try {
      final box = await boxManager.openBox(_authBox);
      return box.get(_challengeTokenKey) as String?;
    } catch (e, st) {
      AppLogger.instance.e('getChallengeToken failed', e, st);
      return null;
    }
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
   Future<void> saveFcmToken(String token) async {
    try {
      final box = await boxManager.openBox(_authBox);
      await box.put('fcmToken', token);
    } catch (e, st) {
      AppLogger.instance.e('saveFcmToken failed', e, st);
    }
  }
  

  Future<void> saveAuthResponse(AuthResponseModel response) async {
    try {
      await boxManager.openBox(_authBox);
      await saveUserData(response.user);
      if (response.patient != null) {
        await savePatientData(response.patient!);
      }
      if (response.doctor != null) {
        await saveDoctorData(response.doctor!);
      }
      await saveAccessToken(response.accessToken);
      await saveRefreshToken(response.refreshToken);
      await _logAuthSnapshot(
        hasPatient: response.patient != null,
        hasDoctor: response.doctor != null,
      );
    } catch (e, st) {
      AppLogger.instance.e('saveAuthResponse failed', e, st);
    }
  }

  Future<void> saveUserData(UserModel user) async {
    final box = await boxManager.openBox('userBox');
    await box.put('userData', user.toJson());
    if (user.id.isNotEmpty) {
      final settingsBox = await boxManager.openBox('settingsBox');
      await settingsBox.put('lastKnownUserId', user.id);
    }
  }

  Future<void> savePatientData(PatientModel patient) async {
    final box = await boxManager.openBox('userBox');
    await box.put('patientData', patient.toJson());
    await box.delete('doctorData');
  }

  Future<void> saveDoctorData(DoctorModel doctor) async {
    final box = await boxManager.openBox('userBox');
    await box.put('doctorData', doctor.toJson());
    await box.delete('patientData');
  }

  Future<void> _logAuthSnapshot({
    required bool hasPatient,
    required bool hasDoctor,
  }) async {
    try {
      final authBox = await boxManager.openBox(_authBox);
      final userBox = await boxManager.openBox('userBox');
      AppLogger.instance.i('Auth box keys: ${authBox.keys.toList()}');
      AppLogger.instance.i('Auth box values: ${authBox.toMap()}');
      AppLogger.instance.i('User box keys: ${userBox.keys.toList()}');
      AppLogger.instance.i('User box values: ${userBox.toMap()}');
      AppLogger.instance.i('Saved user exists after auth save: ${userBox.get('userData') != null}');
      AppLogger.instance.i('Saved patient exists after auth save: $hasPatient');
      AppLogger.instance.i('Saved doctor exists after auth save: $hasDoctor');
    } catch (e, st) {
      AppLogger.instance.w('Auth snapshot logging failed', e, st);
    }
  }
}
