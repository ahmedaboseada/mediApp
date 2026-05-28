import 'package:medi/core/enums/user_role.dart';
import 'package:medi/core/services/hive_box_manager.dart';
import 'package:medi/core/services/app_logger.dart';

class SettingsLocalDataSource {
  final HiveBoxManager boxManager;
  static const String _settingsBox = 'settingsBox';
  static const String _onboardingCompletedKey = 'onboardingCompleted';
  static const String _completeProfileRequiredKey = 'completeProfileRequired';
  static const String _earlyVoiceAlertsKey = 'earlyVoiceAlerts';
  static const String _notificationsEnabledKey = 'notificationsEnabled';
  static const String _unreadNotificationsCountKey = 'unreadNotificationsCount';
  static const String _emergencyContactKey = 'emergencyContact';

  SettingsLocalDataSource({HiveBoxManager? boxManager}) : boxManager = boxManager ?? const HiveBoxManager();

  Future<void> markOnboardingAsCompleted() async {
    final box = await boxManager.openBox(_settingsBox);
    await box.put(_onboardingCompletedKey, true);
  }

  Future<void> markOnboardingAsNotCompleted() async {
    final box = await boxManager.openBox(_settingsBox);
    await box.put(_onboardingCompletedKey, false);
  }

  Future<bool> isOnboardingCompleted() async {
    try {
      final box = await boxManager.openBox(_settingsBox);
      return box.get(_onboardingCompletedKey, defaultValue: false) as bool;
    } catch (e, st) {
      AppLogger.instance.e('isOnboardingCompleted failed', e, st);
      return false;
    }
  }

  Future<void> markCompleteProfileAsRequired() async {
    final box = await boxManager.openBox(_settingsBox);
    await box.put(_completeProfileRequiredKey, true);
  }

  Future<void> markCompleteProfileAsCompleted() async {
    final box = await boxManager.openBox(_settingsBox);
    await box.put(_completeProfileRequiredKey, false);
  }

  Future<bool> isCompleteProfileRequired() async {
    try {
      final box = await boxManager.openBox(_settingsBox);
      return box.get(_completeProfileRequiredKey, defaultValue: false) as bool;
    } catch (e, st) {
      AppLogger.instance.e('isCompleteProfileRequired failed', e, st);
      return false;
    }
  }

  Future<void> setEarlyVoiceAlerts(bool enabled) async {
    final box = await boxManager.openBox(_settingsBox);
    await box.put(_earlyVoiceAlertsKey, enabled);
  }

  Future<bool> getEarlyVoiceAlerts() async {
    try {
      final box = await boxManager.openBox(_settingsBox);
      return box.get(_earlyVoiceAlertsKey, defaultValue: false) as bool;
    } catch (e, st) {
      AppLogger.instance.e('getEarlyVoiceAlerts failed', e, st);
      return false;
    }
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final box = await boxManager.openBox(_settingsBox);
    await box.put(_notificationsEnabledKey, enabled);
  }

  Future<bool> getNotificationsEnabled() async {
    try {
      final box = await boxManager.openBox(_settingsBox);
      return box.get(_notificationsEnabledKey, defaultValue: true) as bool;
    } catch (e, st) {
      AppLogger.instance.e('getNotificationsEnabled failed', e, st);
      return true;
    }
  }

  Future<void> saveEmergencyContact(Map<String, dynamic> contact) async {
    final box = await boxManager.openBox(_settingsBox);
    await box.put(_emergencyContactKey, contact);
  }

  Future<Map<String, dynamic>?> getEmergencyContact() async {
    try {
      final box = await boxManager.openBox(_settingsBox);
      final raw = box.get(_emergencyContactKey);
      if (raw == null) return null;
      return Map<String, dynamic>.from(raw as Map);
    } catch (e, st) {
      AppLogger.instance.e('getEmergencyContact failed', e, st);
      return null;
    }
  }

  Future<void> clearEmergencyContact() async {
    final box = await boxManager.openBox(_settingsBox);
    await box.delete(_emergencyContactKey);
  }

  Future<void> incrementUnreadNotificationsCount() async {
    final box = await boxManager.openBox(_settingsBox);
    final current = box.get(_unreadNotificationsCountKey, defaultValue: 0) as int;
    await box.put(_unreadNotificationsCountKey, current + 1);
  }

  Future<void> setUnreadNotificationsCount(int count) async {
    final box = await boxManager.openBox(_settingsBox);
    await box.put(_unreadNotificationsCountKey, count < 0 ? 0 : count);
  }

  Future<int> getUnreadNotificationsCount() async {
    try {
      final box = await boxManager.openBox(_settingsBox);
      return box.get(_unreadNotificationsCountKey, defaultValue: 0) as int;
    } catch (e, st) {
      AppLogger.instance.e('getUnreadNotificationsCount failed', e, st);
      return 0;
    }
  }

  Future<void> markNotificationsAsRead() async {
    await setUnreadNotificationsCount(0);
  }

  Future<void> saveUserRole(UserRole role) async {
    final box = await boxManager.openBox(_settingsBox);
    await box.put('userRole', role.toString());
  }

  Future<UserRole?> getUserRole() async {
    try {
      final box = await boxManager.openBox(_settingsBox);
      final roleString = box.get('userRole') as String?;
      if (roleString == null) return null;
      return roleString == 'UserRole.doctor' ? UserRole.doctor : UserRole.patient;
    } catch (e, st) {
      AppLogger.instance.e('getUserRole failed', e, st);
      return null;
    }
  }
}
