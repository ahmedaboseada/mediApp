import 'dart:developer';
import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:medi/core/enums/user_role.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';
import 'package:medi/features/shared/auth/data/models/auth_response_model.dart';
import 'package:medi/features/shared/auth/data/models/caregiver_model.dart';
import 'package:medi/features/shared/auth/data/models/clinic_location_model.dart';
import 'package:medi/features/shared/auth/data/models/doctor_model.dart';
import 'package:medi/features/shared/auth/data/models/user_model.dart';
import 'package:medi/features/shared/auth/data/models/patient_model.dart';
import 'package:medi/features/shared/auth/data/models/working_hours_model.dart';
import 'package:medi/core/data/sync/sync_service.dart';
import 'package:medi/core/data/sync/sync_action.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class HiveService {
  static const String _authBox = 'authBox';
  static const String _userBox = 'userBox';
  static const String _settingsBox = 'settingsBox';
  static const String _medicationsBox = 'medicationsBox';
  static const String _notificationsBox = 'notificationInboxBox';
  static const String _medicationsKey = 'medications';
  static const String _earlyVoiceAlertsKey = 'earlyVoiceAlerts';
  static const String _notificationsEnabledKey = 'notificationsEnabled';
  static const String _unreadNotificationsCountKey = 'unreadNotificationsCount';

  static const String settingsBoxName = _settingsBox;
  static const String unreadNotificationsCountKey =
      _unreadNotificationsCountKey;

  // Keys
  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';
  static const String _challengeTokenKey = 'challengeToken';
  static const String _userDataKey = 'userData';
  static const String _patientDataKey = 'patientData';
  static const String _doctorDataKey = 'doctorData';
  static const String _userRoleKey = 'userRole';
  static const String _onboardingCompletedKey = 'onboardingCompleted';
  static const String _completeProfileRequiredKey = 'completeProfileRequired';
  static const String _userCountryKey = 'userCountry';
  static const String _emergencyContactKey = 'emergencyContact';
  static Future<void>? _initFuture;

  static Future<void> _ensureInitialized() {
    _initFuture ??= init();
    return _initFuture!;
  }

  static Future<Box> _openAuthBox() async {
    await _ensureInitialized();
    if (!Hive.isBoxOpen(_authBox)) {
      await Hive.openBox(_authBox);
    }
    return Hive.box(_authBox);
  }

  static Future<Box> _openUserBox() async {
    await _ensureInitialized();
    if (!Hive.isBoxOpen(_userBox)) {
      await Hive.openBox(_userBox);
    }
    return Hive.box(_userBox);
  }

  static Future<Box> _openSettingsBox() async {
    await _ensureInitialized();
    if (!Hive.isBoxOpen(_settingsBox)) {
      await Hive.openBox(_settingsBox);
    }
    return Hive.box(_settingsBox);
  }

  /// Safely open a Hive box, recovering from corrupted/stale data.
  static Future<Box> _safeOpenBox(String boxName) async {
    try {
      return await Hive.openBox(boxName);
    } catch (e) {
      // Box contains data from a removed adapter or stale on-disk state.
      // Delete if possible, but keep startup alive even if the lock file is already gone.
      try {
        await Hive.deleteBoxFromDisk(boxName);
      } catch (deleteError) {
        log('Failed to delete box $boxName: $deleteError');
      }

      try {
        await _forceDeleteBoxFiles(boxName);
      } catch (forceDeleteError) {
        log('Failed to force-delete box $boxName files: $forceDeleteError');
      }

      log('the deleted box is $boxName');

      try {
        return await Hive.openBox(boxName);
      } catch (reopenError) {
        log('Failed to reopen box $boxName after cleanup: $reopenError');
        rethrow;
      }
    }
  }

  static Future<void> _forceDeleteBoxFiles(String boxName) async {
    final directory = await getApplicationDocumentsDirectory();
    final candidates = <String>[
      boxName,
      '$boxName.hive',
      '$boxName.lock',
      '$boxName.hive.lock',
    ];

    for (final name in candidates) {
      final file = File('${directory.path}${Platform.pathSeparator}$name');
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  /// Initialize Hive
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(PatientModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(AuthResponseModelAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(DoctorModelAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(WorkingHoursModelAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(ClinicLocationModelAdapter());
    }
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(CaregiverModelAdapter());
    }
    if (!Hive.isAdapterRegistered(7)) {
      Hive.registerAdapter(MedicationAdapter());
    }

    // if (!Hive.isAdapterRegistered(9)) {
    //    Hive.registerAdapter(MedicationScheduleTimeAdapter());
    // }
    if (!Hive.isAdapterRegistered(10)) {
      Hive.registerAdapter(SyncActionAdapter());
    }

    // Open boxes (with recovery for corrupted/stale data)
    await _safeOpenBox(_authBox);
    await _safeOpenBox(_userBox);
    await _safeOpenBox(_settingsBox);
    await _safeOpenBox(_medicationsBox);

    // Trigger sync on app start
    SyncService.processQueue();
  }

  static Future<Box> _openMedicationsBox() async {
    await _ensureInitialized();
    if (!Hive.isBoxOpen(_medicationsBox)) {
      await Hive.openBox(_medicationsBox);
    }
    return Hive.box(_medicationsBox);
  }

  static String _currentMedicationsKey() {
    final role = getUserRole();
    final user = getUserData();
    if (role != null && user != null && user.id.isNotEmpty) {
      final roleLabel = role == UserRole.doctor ? 'doctor' : 'patient';
      return '$_medicationsKey/$roleLabel/${user.id}';
    }
    return _medicationsKey;
  }

  // ========== TOKEN MANAGEMENT ==========

  /// Save access token
  static Future<void> saveAccessToken(String token) async {
    final auth = await _openAuthBox();
    await auth.put(_accessTokenKey, token);
  }

  /// Get access token
  static String? getAccessToken() {
    if (!Hive.isBoxOpen(_authBox)) return null;
    return Hive.box(_authBox).get(_accessTokenKey) as String?;
  }

  /// Save refresh token
  static Future<void> saveRefreshToken(String token) async {
    final auth = await _openAuthBox();
    await auth.put(_refreshTokenKey, token);
  }

  /// Get refresh token
  static String? getRefreshToken() {
    if (!Hive.isBoxOpen(_authBox)) return null;
    return Hive.box(_authBox).get(_refreshTokenKey) as String?;
  }

  /// Save challenge token (for 2FA)
  static Future<void> saveChallengeToken(String token) async {
    final auth = await _openAuthBox();
    await auth.put(_challengeTokenKey, token);
  }

  /// Get challenge token
  static String? getChallengeToken() {
    if (!Hive.isBoxOpen(_authBox)) return null;
    return Hive.box(_authBox).get(_challengeTokenKey) as String?;
  }

  /// Clear challenge token
  static Future<void> clearChallengeToken() async {
    final auth = await _openAuthBox();
    await auth.delete(_challengeTokenKey);
  }

  /// Clear all tokens
  static Future<void> clearTokens() async {
    final auth = await _openAuthBox();
    await auth.delete(_accessTokenKey);
    await auth.delete(_refreshTokenKey);
    await auth.delete(_challengeTokenKey);
  }

  // ========== USER DATA MANAGEMENT ==========

  /// Save auth response from signup/signin flow.
  static Future<void> saveAuthResponse(AuthResponseModel response) async {
    final userBox = await _openUserBox();
    await userBox.put(_userDataKey, response.user);
    if (response.patient != null) {
      await userBox.put(_patientDataKey, response.patient);
      await userBox.delete(_doctorDataKey);
      await saveMedications(response.patient!.medications);
    }
    if (response.doctor != null) {
      await userBox.put(_doctorDataKey, response.doctor);
      await userBox.delete(_patientDataKey);
    }
    await saveAccessToken(response.accessToken);
    await saveRefreshToken(response.refreshToken);

    final userRole = response.user.type == 'doctor'
        ? UserRole.doctor
        : UserRole.patient;
    await saveUserRole(userRole);
  }

  /// Get user data
  static UserModel? getUserData() {
    if (!Hive.isBoxOpen(_userBox)) return null;
    try {
      return Hive.box(_userBox).get(_userDataKey) as UserModel?;
    } catch (_) {
      Hive.box(_userBox).delete(_userDataKey);
      return null;
    }
  }

  /// Save user data
  static Future<void> saveUserData(UserModel user) async {
    final userBox = await _openUserBox();
    await userBox.put(_userDataKey, user);
  }

  /// Get patient data
  static PatientModel? getPatientData() {
    if (!Hive.isBoxOpen(_userBox)) return null;
    try {
      return Hive.box(_userBox).get(_patientDataKey) as PatientModel?;
    } catch (_) {
      Hive.box(_userBox).delete(_patientDataKey);
      return null;
    }
  }

  /// Save patient data
  static Future<void> savePatientData(PatientModel patient) async {
    final userBox = await _openUserBox();
    await userBox.put(_patientDataKey, patient);
    await userBox.delete(_doctorDataKey);
  }

  /// Get doctor data
  static DoctorModel? getDoctorData() {
    if (!Hive.isBoxOpen(_userBox)) return null;
    try {
      return Hive.box(_userBox).get(_doctorDataKey) as DoctorModel?;
    } catch (_) {
      Hive.box(_userBox).delete(_doctorDataKey);
      return null;
    }
  }

  /// Save doctor data
  static Future<void> saveDoctorData(DoctorModel doctor) async {
    final userBox = await _openUserBox();
    await userBox.put(_doctorDataKey, doctor);
    await userBox.delete(_patientDataKey);
  }

  /// Save user profile (for compatibility with existing code)
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
    final settings = await _openSettingsBox();
    if (country != null) {
      await settings.put(_userCountryKey, country);
    }

    final currentUser = getUserData();
    if (currentUser != null) {
      final updatedUser = UserModel(
        id: currentUser.id,
        type: currentUser.type,
        firstName: firstName ?? currentUser.firstName,
        lastName: lastName ?? currentUser.lastName,
        email: email ?? currentUser.email,
        gender: gender ?? currentUser.gender,
        dob: dateOfBirth ?? currentUser.dob,
        phone: phone ?? currentUser.phone,
        twoFA: currentUser.twoFA,
        profilePicture: profileImage ?? currentUser.profilePicture,
        confirmed: currentUser.confirmed,
      );
      await saveUserData(updatedUser);
    }
  }

  // ========== EMERGENCY CONTACT HELPERS ==========

  /// Save emergency contact locally
  static Future<void> saveEmergencyContact(Map<String, dynamic> contact) async {
    final settings = await _openSettingsBox();
    await settings.put(_emergencyContactKey, contact);
  }

  /// Get locally saved emergency contact
  static Map<String, dynamic>? getEmergencyContact() {
    if (!Hive.isBoxOpen(_settingsBox)) return null;
    final raw = Hive.box(_settingsBox).get(_emergencyContactKey);
    if (raw == null) return null;
    return Map<String, dynamic>.from(raw as Map);
  }

  /// Clear locally saved emergency contact
  static Future<void> clearEmergencyContact() async {
    final settings = await _openSettingsBox();
    await settings.delete(_emergencyContactKey);
  }

  // ========== USER ROLE MANAGEMENT ==========

  /// Save user role
  static Future<void> saveUserRole(UserRole role) async {
    final settings = await _openSettingsBox();
    await settings.put(_userRoleKey, role.toString());
  }

  /// Get user role
  static UserRole? getUserRole() {
    if (!Hive.isBoxOpen(_settingsBox)) return null;
    final roleString = Hive.box(_settingsBox).get(_userRoleKey);
    if (roleString == null) return null;

    return roleString == 'UserRole.doctor' ? UserRole.doctor : UserRole.patient;
  }

  // ========== ONBOARDING MANAGEMENT ==========

  /// Mark onboarding as completed
  static Future<void> markOnboardingAsCompleted() async {
    final settings = await _openSettingsBox();
    await settings.put(_onboardingCompletedKey, true);
  }

  /// Mark onboarding as not completed
  static Future<void> markOnboardingAsNotCompleted() async {
    final settings = await _openSettingsBox();
    await settings.put(_onboardingCompletedKey, false);
  }

  /// Check if onboarding is completed
  static bool isOnboardingCompleted() {
    if (!Hive.isBoxOpen(_settingsBox)) return false;
    return Hive.box(
          _settingsBox,
        ).get(_onboardingCompletedKey, defaultValue: false)
        as bool;
  }

  // ========== COMPLETE PROFILE FLOW MANAGEMENT ==========

  /// Mark complete profile as required.
  static Future<void> markCompleteProfileAsRequired() async {
    final settings = await _openSettingsBox();
    await settings.put(_completeProfileRequiredKey, true);
  }

  /// Mark complete profile as completed.
  static Future<void> markCompleteProfileAsCompleted() async {
    final settings = await _openSettingsBox();
    await settings.put(_completeProfileRequiredKey, false);
  }

  /// Check if complete profile flow is required.
  static bool isCompleteProfileRequired() {
    if (!Hive.isBoxOpen(_settingsBox)) return false;
    return Hive.box(
          _settingsBox,
        ).get(_completeProfileRequiredKey, defaultValue: false)
        as bool;
  }

  // ========== USER PROFILE HELPERS ==========

  /// Get user profile as a map (for compatibility with PrefHelper)
  static Map<String, String?> getUserProfile() {
    final user = getUserData();
    if (user == null) return {};

    final country = Hive.isBoxOpen(_settingsBox)
        ? Hive.box(_settingsBox).get(_userCountryKey) as String?
        : null;

    return {
      'firstName': user.firstName,
      'lastName': user.lastName,
      'email': user.email,
      'phone': user.phone,
      'country': country,
      'dateOfBirth': user.dob,
      'gender': user.gender,
      'profileImage': user.profilePicture,
    };
  }

  /// Get user email
  static String? getEmail() {
    final user = getUserData();
    return user?.email;
  }

  /// Check if two-factor auth is enabled
  static bool isTwoFactorEnabled() {
    final user = getUserData();
    return user?.twoFA ?? false;
  }

  /// Set two-factor auth status
  static Future<void> setTwoFactorEnabled(bool enabled) async {
    final user = getUserData();
    if (user != null) {
      final updatedUser = UserModel(
        id: user.id,
        type: user.type,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        gender: user.gender,
        twoFA: enabled,
        profilePicture: user.profilePicture,
        confirmed: user.confirmed,
      );
      await saveUserData(updatedUser);
    }
  }

  // ========== EARLY VOICE ALERTS ==========

  /// Save the early voice alerts preference
  static Future<void> setEarlyVoiceAlerts(bool enabled) async {
    if (!Hive.isBoxOpen(_settingsBox)) return;
    await Hive.box(_settingsBox).put(_earlyVoiceAlertsKey, enabled);
  }

  /// Get whether early voice alerts are enabled
  static bool getEarlyVoiceAlerts() {
    if (!Hive.isBoxOpen(_settingsBox)) return false;
    return Hive.box(_settingsBox).get(_earlyVoiceAlertsKey, defaultValue: false)
        as bool;
  }

  /// Save the notifications enabled preference
  static Future<void> setNotificationsEnabled(bool enabled) async {
    if (!Hive.isBoxOpen(_settingsBox)) return;
    await Hive.box(_settingsBox).put(_notificationsEnabledKey, enabled);
  }

  /// Get whether notifications are enabled (defaults to true)
  static bool getNotificationsEnabled() {
    if (!Hive.isBoxOpen(_settingsBox)) return true;
    return Hive.box(
          _settingsBox,
        ).get(_notificationsEnabledKey, defaultValue: true)
        as bool;
  }

  /// Increment the unread notification badge count.
  static Future<void> incrementUnreadNotificationsCount() async {
    if (!Hive.isBoxOpen(_settingsBox)) return;
    final box = Hive.box(_settingsBox);
    final current = box.get(_unreadNotificationsCountKey, defaultValue: 0) as int;
    await box.put(_unreadNotificationsCountKey, current + 1);
  }

  /// Save the unread notification badge count.
  static Future<void> setUnreadNotificationsCount(int count) async {
    if (!Hive.isBoxOpen(_settingsBox)) return;
    await Hive.box(_settingsBox).put(
      _unreadNotificationsCountKey,
      count < 0 ? 0 : count,
    );
  }

  /// Return the unread notification badge count.
  static int getUnreadNotificationsCount() {
    if (!Hive.isBoxOpen(_settingsBox)) return 0;
    return Hive.box(
          _settingsBox,
        ).get(_unreadNotificationsCountKey, defaultValue: 0)
        as int;
  }

  /// Mark every notification as read.
  static Future<void> markNotificationsAsRead() async {
    await setUnreadNotificationsCount(0);
  }

  // ========== MEDICATION MANAGEMENT ==========

  /// Get locally saved medications
  static List<Medication> getMedications() {
    if (!Hive.isBoxOpen(_medicationsBox)) return [];
    final raw = Hive.box(_medicationsBox).get(_currentMedicationsKey());
    if (raw == null) return [];
    return (raw as List).map((e) => Medication.fromJson(e as Map)).toList();
  }

  /// Save the full list of medications
  static Future<void> saveMedications(List<Medication> medications) async {
    final box = await _openMedicationsBox();
    await box.put(
      _currentMedicationsKey(),
      medications.map((m) => m.toJson()).toList(),
    );
  }

  /// Add a single medication to the saved list
  static Future<void> addMedication(Medication medication) async {
    var medicationWithId = medication;
    if (medication.id.isEmpty) {
      medicationWithId = medication.copyWith(id: const Uuid().v4());
    }

    // Set as not synced initially for offline-first tracking
    medicationWithId = medicationWithId.copyWith(isSynced: false);

    final current = getMedications();
    current.add(medicationWithId);
    await saveMedications(current);

    // Push to sync queue
    await SyncService.addToQueue(
      type: 'add',
      entity: 'medication',
      data: medicationWithId.toJson(),
    );
  }

  /// Update a medication in the locally saved list.
  static Future<void> updateMedication({
    required Medication original,
    required Medication updated,
  }) async {
    final current = getMedications();
    var index = current.indexWhere((m) => m == original);

    if (index == -1) {
      index = current.indexWhere(
        (m) =>
            m.name == original.name &&
            m.type == original.type &&
            m.dosage == original.dosage &&
            m.startDate == original.startDate &&
            m.endDate == original.endDate,
      );
    }

    final medicationToSync = updated.copyWith(isSynced: false);

    if (index == -1) {
      current.add(medicationToSync);
    } else {
      current[index] = medicationToSync;
    }

    await saveMedications(current);

    // Push to sync queue
    await SyncService.addToQueue(
      type: 'update',
      entity: 'medication',
      data: medicationToSync.toJson(),
    );
  }

  /// Delete a medication from the locally saved list.
  static Future<void> deleteMedication(Medication medication) async {
    final current = getMedications();
    var index = current.indexWhere((m) => m == medication);

    if (index == -1) {
      index = current.indexWhere(
        (m) =>
            m.name == medication.name &&
            m.type == medication.type &&
            m.dosage == medication.dosage &&
            m.startDate == medication.startDate &&
            m.endDate == medication.endDate,
      );
    }

    if (index != -1) {
      current.removeAt(index);
      await saveMedications(current);

      // Push to sync queue
      await SyncService.addToQueue(
        type: 'delete',
        entity: 'medication',
        data: medication.toJson(),
      );
    }
  }

  // ========== SYNC HELPERS ==========

  /// Mark a medication as synced in local storage
  static Future<void> markMedicationSynced(String id) async {
    final current = getMedications();
    final index = current.indexWhere((m) => m.id == id);
    if (index != -1) {
      current[index] = current[index].copyWith(isSynced: true);
      await saveMedications(current);
    }
  }

  /// Update a temporary ID with a server-generated ID
  static Future<void> updateMedicationServerId(
    String tempId,
    String serverId,
  ) async {
    final current = getMedications();
    final index = current.indexWhere((m) => m.id == tempId);
    if (index != -1) {
      current[index] = current[index].copyWith(id: serverId, isSynced: true);
      await saveMedications(current);
    }
  }

  // ========== CLEAR ALL DATA ==========

  /// Clear all data (logout)
  static Future<void> clearAllData() async {
    final auth = await _openAuthBox();
    final userBox = await _openUserBox();
    final settings = await _openSettingsBox();
    final meds = await _openMedicationsBox();
    if (Hive.isBoxOpen(_notificationsBox)) {
      await Hive.box(_notificationsBox).clear();
    }
    await auth.clear();
    await userBox.clear();
    await settings.clear();
    await meds.clear();
    await Hive.deleteBoxFromDisk(_authBox);
    await Hive.deleteBoxFromDisk(_userBox);
    await Hive.deleteBoxFromDisk(_settingsBox);
    await Hive.deleteBoxFromDisk(_medicationsBox);
    await Hive.deleteBoxFromDisk(_notificationsBox);
  }

  /// Close all boxes
  static Future<void> close() async {
    await Hive.close();
    _initFuture = null;
  }
}
