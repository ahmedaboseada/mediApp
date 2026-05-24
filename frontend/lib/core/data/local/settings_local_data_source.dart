import 'package:hive_flutter/hive_flutter.dart';
import 'package:medi/core/enums/user_role.dart';
import 'package:medi/core/services/hive_box_manager.dart';

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

  bool isOnboardingCompleted() {
    if (!Hive.isBoxOpen(_settingsBox)) return false;
    return Hive.box(_settingsBox).get(_onboardingCompletedKey, defaultValue: false) as bool;
  }

  Future<void> markCompleteProfileAsRequired() async {
    final box = await boxManager.openBox(_settingsBox);
    await box.put(_completeProfileRequiredKey, true);
  }

  Future<void> markCompleteProfileAsCompleted() async {
    final box = await boxManager.openBox(_settingsBox);
    await box.put(_completeProfileRequiredKey, false);
  }

  bool isCompleteProfileRequired() {
    if (!Hive.isBoxOpen(_settingsBox)) return false;
    return Hive.box(_settingsBox).get(_completeProfileRequiredKey, defaultValue: false) as bool;
  }

  Future<void> setEarlyVoiceAlerts(bool enabled) async {
    if (!Hive.isBoxOpen(_settingsBox)) return;
    await Hive.box(_settingsBox).put(_earlyVoiceAlertsKey, enabled);
  }

  bool getEarlyVoiceAlerts() {
    if (!Hive.isBoxOpen(_settingsBox)) return false;
    return Hive.box(_settingsBox).get(_earlyVoiceAlertsKey, defaultValue: false) as bool;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    if (!Hive.isBoxOpen(_settingsBox)) return;
    await Hive.box(_settingsBox).put(_notificationsEnabledKey, enabled);
  }

  bool getNotificationsEnabled() {
    if (!Hive.isBoxOpen(_settingsBox)) return true;
    return Hive.box(_settingsBox).get(_notificationsEnabledKey, defaultValue: true) as bool;
  }

  Future<void> saveEmergencyContact(Map<String, dynamic> contact) async {
    final box = await boxManager.openBox(_settingsBox);
    await box.put(_emergencyContactKey, contact);
  }

  Map<String, dynamic>? getEmergencyContact() {
    if (!Hive.isBoxOpen(_settingsBox)) return null;
    final raw = Hive.box(_settingsBox).get(_emergencyContactKey);
    if (raw == null) return null;
    return Map<String, dynamic>.from(raw as Map);
  }

  Future<void> clearEmergencyContact() async {
    final box = await boxManager.openBox(_settingsBox);
    await box.delete(_emergencyContactKey);
  }

  Future<void> incrementUnreadNotificationsCount() async {
    if (!Hive.isBoxOpen(_settingsBox)) return;
    final box = Hive.box(_settingsBox);
    final current = box.get(_unreadNotificationsCountKey, defaultValue: 0) as int;
    await box.put(_unreadNotificationsCountKey, current + 1);
  }

  Future<void> setUnreadNotificationsCount(int count) async {
    if (!Hive.isBoxOpen(_settingsBox)) return;
    await Hive.box(_settingsBox).put(_unreadNotificationsCountKey, count < 0 ? 0 : count);
  }

  int getUnreadNotificationsCount() {
    if (!Hive.isBoxOpen(_settingsBox)) return 0;
    return Hive.box(_settingsBox).get(_unreadNotificationsCountKey, defaultValue: 0) as int;
  }

  Future<void> markNotificationsAsRead() async {
    await setUnreadNotificationsCount(0);
  }

  Future<void> saveUserRole(UserRole role) async {
    final box = await boxManager.openBox(_settingsBox);
    await box.put('userRole', role.toString());
  }

  UserRole? getUserRole() {
    if (!Hive.isBoxOpen(_settingsBox)) return null;
    final roleString = Hive.box(_settingsBox).get('userRole') as String?;
    if (roleString == null) return null;
    return roleString == 'UserRole.doctor' ? UserRole.doctor : UserRole.patient;
  }
}
