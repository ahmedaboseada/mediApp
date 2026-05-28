// A compact facade that preserves the original `HiveService` static API
// while delegating implementation to smaller, testable data sources.
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medi/core/services/hive_box_manager.dart';
import 'package:medi/core/services/hive_initializer.dart';
import 'package:medi/core/data/local/auth_local_data_source.dart';
import 'package:medi/core/data/local/user_local_data_source.dart';
import 'package:medi/core/data/local/settings_local_data_source.dart';
import 'package:medi/core/data/local/medication_local_data_source.dart';
import 'package:medi/core/data/local/schedule_local_data_source.dart';
import 'package:medi/core/data/local/notification_local_data_source.dart';
import 'package:medi/core/data/local/health_logs_local_data_source.dart';
import 'package:medi/core/data/local/booking_local_data_source.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';
import 'package:medi/features/shared/auth/data/models/auth_response_model.dart';
import 'package:medi/features/shared/auth/data/models/user_model.dart';
import 'package:medi/features/shared/auth/data/models/patient_model.dart';
import 'package:medi/features/shared/auth/data/models/doctor_model.dart';
import 'package:medi/core/enums/user_role.dart';
import 'package:medi/core/services/app_logger.dart';

class HiveService {
  static const String settingsBoxName = 'settingsBox';
  static const String notificationInboxBoxName = 'notificationInboxBox';
  static const String unreadNotificationsCountKey = 'unreadNotificationsCount';

  static final HiveBoxManager _boxManager = const HiveBoxManager();
  static final HiveInitializer _initializer = HiveInitializer(boxManager: _boxManager);

  static final AuthLocalDataSource _auth = AuthLocalDataSource(boxManager: _boxManager);
  static final UserLocalDataSource _user = UserLocalDataSource(boxManager: _boxManager);
  static final SettingsLocalDataSource _settings = SettingsLocalDataSource(boxManager: _boxManager);
  static final MedicationLocalDataSource _medication = MedicationLocalDataSource(boxManager: _boxManager);
  static final ScheduleLocalDataSource _schedule = ScheduleLocalDataSource(boxManager: _boxManager, userLocal: _user, settingsLocal: _settings);
  static final NotificationLocalDataSource _notification = NotificationLocalDataSource(boxManager: _boxManager);
  static final HealthLogsLocalDataSource _healthLogs = HealthLogsLocalDataSource(boxManager: _boxManager);
  static final BookingLocalDataSource _bookings = BookingLocalDataSource(boxManager: _boxManager);

  /// Initialize Hive and open common boxes.
  static Future<void> init() async {
    await _initializer.init();
  }

  // ========== Tokens & Auth ==========
  static Future<void> saveAccessToken(String token) => _auth.saveAccessToken(token);
  static Future<String?> getAccessToken() => _auth.getAccessToken();
  static Future<void> saveRefreshToken(String token) => _auth.saveRefreshToken(token);
  static Future<String?> getRefreshToken() => _auth.getRefreshToken();
  static Future<void> saveChallengeToken(String token) => _auth.saveChallengeToken(token);
  static Future<String?> getChallengeToken() => _auth.getChallengeToken();
  static Future<void> clearChallengeToken() => _auth.clearChallengeToken();
  static Future<void> clearTokens() => _auth.clearTokens();

  static Future<void> saveAuthResponse(AuthResponseModel response) => _auth.saveAuthResponse(response);

  // ========== User Data ==========
  static Future<UserModel?> getUserData() => _user.getUserData();
  static Future<String?> getLastKnownUserId() => _user.getLastKnownUserId();
  static Future<void> saveUserData(UserModel user) => _user.saveUserData(user);
  static Future<PatientModel?> getPatientData() => _user.getPatientData();
  static Future<void> savePatientData(PatientModel patient) => _user.savePatientData(patient);
  static Future<DoctorModel?> getDoctorData() => _user.getDoctorData();
  static Future<void> saveDoctorData(DoctorModel doctor) => _user.saveDoctorData(doctor);
  static Future<void> saveUserProfile({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? country,
    String? dateOfBirth,
    String? gender,
    String? profileImage,
  }) =>
      _user.saveUserProfile(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        country: country,
        dateOfBirth: dateOfBirth,
        gender: gender,
        profileImage: profileImage,
      );
  static Future<Map<String, String?>> getUserProfile() => _user.getUserProfile();
  static Future<String?> getEmail() => _user.getEmail();
  static Future<bool> isTwoFactorEnabled() => _user.isTwoFactorEnabled();
  static Future<void> setTwoFactorEnabled(bool enabled) => _user.setTwoFactorEnabled(enabled);

  // ========== Settings ==========
  static Future<void> markOnboardingAsCompleted() => _settings.markOnboardingAsCompleted();
  static Future<void> markOnboardingAsNotCompleted() => _settings.markOnboardingAsNotCompleted();
  static Future<bool> isOnboardingCompleted() => _settings.isOnboardingCompleted();
  static Future<void> markCompleteProfileAsRequired() => _settings.markCompleteProfileAsRequired();
  static Future<void> markCompleteProfileAsCompleted() => _settings.markCompleteProfileAsCompleted();
  static Future<bool> isCompleteProfileRequired() => _settings.isCompleteProfileRequired();
  static Future<void> setEarlyVoiceAlerts(bool enabled) => _settings.setEarlyVoiceAlerts(enabled);
  static Future<bool> getEarlyVoiceAlerts() => _settings.getEarlyVoiceAlerts();
  static Future<void> setNotificationsEnabled(bool enabled) => _settings.setNotificationsEnabled(enabled);
  static Future<bool> getNotificationsEnabled() => _settings.getNotificationsEnabled();
  static Future<void> incrementUnreadNotificationsCount() => _settings.incrementUnreadNotificationsCount();
  static Future<void> setUnreadNotificationsCount(int count) => _settings.setUnreadNotificationsCount(count);
  static Future<int> getUnreadNotificationsCount() => _settings.getUnreadNotificationsCount();
  static Future<void> markNotificationsAsRead() => _settings.markNotificationsAsRead();
  static Future<void> saveEmergencyContact(Map<String, dynamic> contact) => _settings.saveEmergencyContact(contact);
  static Future<Map<String, dynamic>?> getEmergencyContact() => _settings.getEmergencyContact();
  static Future<void> clearEmergencyContact() => _settings.clearEmergencyContact();
  static Future<void> saveUserRole(UserRole role) => _settings.saveUserRole(role);
  static Future<UserRole?> getUserRole() => _settings.getUserRole();

  // ========== Medications ==========
  static Future<List<Medication>> getMedications() async => _medication.getMedications(await _currentMedicationsKey());
  static Future<void> saveMedications(List<Medication> medications) async => _medication.saveMedications(await _currentMedicationsKey(), medications);
  static Future<void> addMedication(Medication medication) async => _medication.addMedication(await _currentMedicationsKey(), medication);
  static Future<void> updateMedication({required Medication original, required Medication updated}) async => _medication.updateMedication(await _currentMedicationsKey(), original: original, updated: updated);
  static Future<void> deleteMedication(Medication medication) async => _medication.deleteMedication(await _currentMedicationsKey(), medication);
  static Future<void> markMedicationSynced(String id) async => _medication.markMedicationSynced(await _currentMedicationsKey(), id);
  static Future<void> updateMedicationServerId(String tempId, String serverId) async => _medication.updateMedicationServerId(await _currentMedicationsKey(), tempId, serverId);

  // ========== Schedule ==========
  static Future<void> saveMedicationSchedule(String date, dynamic scheduleResponse) => _schedule.saveMedicationSchedule(date, scheduleResponse);
  static Future<dynamic> getMedicationSchedule(String date) => _schedule.getMedicationSchedule(date);
  static Future<void> markMedicationScheduleTaken({required String date, required String medicationId, required String time, required bool taken}) => _schedule.markMedicationScheduleTaken(date: date, medicationId: medicationId, time: time, taken: taken);

  // ========== Notifications ==========
  static Future<dynamic> getNotificationInbox() => _notification.getInbox();
  static Future<void> saveNotificationInbox(dynamic payload) => _notification.saveInbox(payload);
  static Future<void> clearNotificationInbox() => _notification.clearInbox();

  // ========== Sync Queue ==========
  static Future<void> addSyncAction(dynamic action) async {
    try {
      if (action is Map) {
        // best-effort: wrap into SyncAction is handled elsewhere
      }
      // keep compatibility: rely on SyncService for advanced operations
    } catch (e, st) {
      AppLogger.instance.e('addSyncAction failed', e, st);
    }
  }

  // ========== Helpers ==========
  static Future<String> _currentMedicationsKey() async {
    final role = await getUserRole();
    final user = await getUserData();
    if (role != null && user != null && user.id.isNotEmpty) {
      final roleLabel = role == UserRole.doctor ? 'doctor' : 'patient';
      return 'medications/$roleLabel/${user.id}';
    }
    return 'medications';
  }

  /// Clear all data (logout)
  static Future<void> clearAllData() async {
    try {
      await Future.wait([
        _boxManager.openBox('authBox').then((box) => box.clear()),
        _boxManager.openBox('userBox').then((box) => box.clear()),
        _boxManager.openBox('settingsBox').then((box) => box.clear()),
        _boxManager.openBox('medicationsBox').then((box) => box.clear()),
        _boxManager.openBox('patientSchedulesBox').then((box) => box.clear()),
        _boxManager.openBox('notificationInboxBox').then((box) => box.clear()),
      ]);
      await _healthLogs.clearAll();
      await _bookings.clearAll();
    } catch (e, st) {
      AppLogger.instance.e('clearAllData failed', e, st);
    }
  }

  static Future<void> close() async {
    await Hive.close();
  }

  static ValueListenable<Box<dynamic>> listenableSettingsBox({List<dynamic>? keys}) {
    return Hive.box(settingsBoxName).listenable(keys: keys);
  }

  static ValueListenable<Box<dynamic>> listenableNotificationInboxBox({List<dynamic>? keys}) {
    return Hive.box(notificationInboxBoxName).listenable(keys: keys);
  }
}

