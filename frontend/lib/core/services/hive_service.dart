// A compact facade that preserves the original `HiveService` static API
// while delegating implementation to smaller, testable data sources.
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
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';
import 'package:medi/features/shared/auth/data/models/auth_response_model.dart';
import 'package:medi/features/shared/auth/data/models/user_model.dart';
import 'package:medi/features/shared/auth/data/models/patient_model.dart';
import 'package:medi/features/shared/auth/data/models/doctor_model.dart';
import 'package:medi/core/enums/user_role.dart';
import 'package:medi/core/services/app_logger.dart';

class HiveService {
  static const String settingsBoxName = 'settingsBox';
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

  /// Initialize Hive and open common boxes.
  static Future<void> init() async {
    await _initializer.init();
  }

  // ========== Tokens & Auth ==========
  static Future<void> saveAccessToken(String token) => _auth.saveAccessToken(token);
  static String? getAccessToken() => _auth.getAccessToken();
  static Future<void> saveRefreshToken(String token) => _auth.saveRefreshToken(token);
  static String? getRefreshToken() => _auth.getRefreshToken();
  static Future<void> saveChallengeToken(String token) => _auth.saveChallengeToken(token);
  static String? getChallengeToken() => _auth.getChallengeToken();
  static Future<void> clearChallengeToken() => _auth.clearChallengeToken();
  static Future<void> clearTokens() => _auth.clearTokens();

  static Future<void> saveAuthResponse(AuthResponseModel response) => _auth.saveAuthResponse(response);

  // ========== User Data ==========
  static UserModel? getUserData() => _user.getUserData();
  static Future<void> saveUserData(UserModel user) => _user.saveUserData(user);
  static PatientModel? getPatientData() => _user.getPatientData();
  static Future<void> savePatientData(PatientModel patient) => _user.savePatientData(patient);
  static DoctorModel? getDoctorData() => _user.getDoctorData();
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
  static Map<String, String?> getUserProfile() => _user.getUserProfile();
  static String? getEmail() => _user.getEmail();
  static bool isTwoFactorEnabled() => _user.isTwoFactorEnabled();
  static Future<void> setTwoFactorEnabled(bool enabled) => _user.setTwoFactorEnabled(enabled);

  // ========== Settings ==========
  static Future<void> markOnboardingAsCompleted() => _settings.markOnboardingAsCompleted();
  static Future<void> markOnboardingAsNotCompleted() => _settings.markOnboardingAsNotCompleted();
  static bool isOnboardingCompleted() => _settings.isOnboardingCompleted();
  static Future<void> markCompleteProfileAsRequired() => _settings.markCompleteProfileAsRequired();
  static Future<void> markCompleteProfileAsCompleted() => _settings.markCompleteProfileAsCompleted();
  static bool isCompleteProfileRequired() => _settings.isCompleteProfileRequired();
  static Future<void> setEarlyVoiceAlerts(bool enabled) => _settings.setEarlyVoiceAlerts(enabled);
  static bool getEarlyVoiceAlerts() => _settings.getEarlyVoiceAlerts();
  static Future<void> setNotificationsEnabled(bool enabled) => _settings.setNotificationsEnabled(enabled);
  static bool getNotificationsEnabled() => _settings.getNotificationsEnabled();
  static Future<void> incrementUnreadNotificationsCount() => _settings.incrementUnreadNotificationsCount();
  static Future<void> setUnreadNotificationsCount(int count) => _settings.setUnreadNotificationsCount(count);
  static int getUnreadNotificationsCount() => _settings.getUnreadNotificationsCount();
  static Future<void> markNotificationsAsRead() => _settings.markNotificationsAsRead();
  static Future<void> saveEmergencyContact(Map<String, dynamic> contact) => _settings.saveEmergencyContact(contact);
  static Map<String, dynamic>? getEmergencyContact() => _settings.getEmergencyContact();
  static Future<void> clearEmergencyContact() => _settings.clearEmergencyContact();
  static Future<void> saveUserRole(UserRole role) => _settings.saveUserRole(role);
  static UserRole? getUserRole() => _settings.getUserRole();

  // ========== Medications ==========
  static List<Medication> getMedications() => _medication.getMedications(_currentMedicationsKey());
  static Future<void> saveMedications(List<Medication> medications) => _medication.saveMedications(_currentMedicationsKey(), medications);
  static Future<void> addMedication(Medication medication) => _medication.addMedication(_currentMedicationsKey(), medication);
  static Future<void> updateMedication({required Medication original, required Medication updated}) => _medication.updateMedication(_currentMedicationsKey(), original: original, updated: updated);
  static Future<void> deleteMedication(Medication medication) => _medication.deleteMedication(_currentMedicationsKey(), medication);
  static Future<void> markMedicationSynced(String id) => _medication.markMedicationSynced(_currentMedicationsKey(), id);
  static Future<void> updateMedicationServerId(String tempId, String serverId) => _medication.updateMedicationServerId(_currentMedicationsKey(), tempId, serverId);

  // ========== Schedule ==========
  static Future<void> saveMedicationSchedule(String date, dynamic scheduleResponse) => _schedule.saveMedicationSchedule(date, scheduleResponse);
  static dynamic getMedicationSchedule(String date) => _schedule.getMedicationSchedule(date);
  static Future<void> markMedicationScheduleTaken({required String date, required String medicationId, required String time, required bool taken}) => _schedule.markMedicationScheduleTaken(date: date, medicationId: medicationId, time: time, taken: taken);

  // ========== Notifications ==========
  static dynamic getNotificationInbox() => _notification.getInbox();
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
  static String _currentMedicationsKey() {
    final role = getUserRole();
    final user = getUserData();
    if (role != null && user != null && user.id.isNotEmpty) {
      final roleLabel = role == UserRole.doctor ? 'doctor' : 'patient';
      return 'medications/$roleLabel/${user.id}';
    }
    return 'medications';
  }

  /// Clear all data (logout)
  static Future<void> clearAllData() async {
    try {
      if (Hive.isBoxOpen('authBox')) await Hive.box('authBox').clear();
      if (Hive.isBoxOpen('userBox')) await Hive.box('userBox').clear();
      if (Hive.isBoxOpen('settingsBox')) await Hive.box('settingsBox').clear();
      if (Hive.isBoxOpen('medicationsBox')) await Hive.box('medicationsBox').clear();
      await _healthLogs.clearAll();
      if (Hive.isBoxOpen('patientSchedulesBox')) await Hive.box('patientSchedulesBox').clear();
      if (Hive.isBoxOpen('notificationInboxBox')) await Hive.box('notificationInboxBox').clear();
    } catch (e, st) {
      AppLogger.instance.e('clearAllData failed', e, st);
    }
  }

  static Future<void> close() async {
    await Hive.close();
  }
}

