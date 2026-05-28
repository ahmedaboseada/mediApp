import 'package:medi/core/services/hive_box_manager.dart';
import 'package:medi/features/shared/auth/data/models/user_model.dart';
import 'package:medi/features/shared/auth/data/models/patient_model.dart';
import 'package:medi/features/shared/auth/data/models/doctor_model.dart';
import 'package:medi/core/services/app_logger.dart';

class UserLocalDataSource {
  final HiveBoxManager boxManager;
  static const String _userBox = 'userBox';
  static const String _settingsBox = 'settingsBox';
  static const String _userDataKey = 'userData';
  static const String _patientDataKey = 'patientData';
  static const String _doctorDataKey = 'doctorData';
  static const String _userCountryKey = 'userCountry';
  static const String _lastKnownUserIdKey = 'lastKnownUserId';

  UserLocalDataSource({HiveBoxManager? boxManager}) : boxManager = boxManager ?? const HiveBoxManager();

  Future<UserModel?> getUserData() async {
    try {
      final box = await boxManager.openBox(_userBox);
      final raw = box.get(_userDataKey);
      if (raw is UserModel) return raw;
      if (raw is Map) {
        return UserModel.fromJson(raw.cast<String, dynamic>());
      }
      return null;
    } catch (e, st) {
      AppLogger.instance.e('getUserData failed', e, st);
      return null;
    }
  }

  Future<void> saveUserData(UserModel user) async {
    try {
      final box = await boxManager.openBox(_userBox);
      await box.put(_userDataKey, user.toJson());
      if (user.id.isNotEmpty) {
        final settingsBox = await boxManager.openBox(_settingsBox);
        await settingsBox.put(_lastKnownUserIdKey, user.id);
      }
    } catch (e, st) {
      AppLogger.instance.e('saveUserData failed', e, st);
    }
  }

  Future<String?> getLastKnownUserId() async {
    try {
      final settingsBox = await boxManager.openBox(_settingsBox);
      final value = settingsBox.get(_lastKnownUserIdKey) as String?;
      if (value == null || value.trim().isEmpty) {
        return null;
      }
      return value.trim();
    } catch (e, st) {
      AppLogger.instance.e('getLastKnownUserId failed', e, st);
      return null;
    }
  }

  Future<PatientModel?> getPatientData() async {
    try {
      final box = await boxManager.openBox(_userBox);
      final raw = box.get(_patientDataKey);
      if (raw is PatientModel) return raw;
      if (raw is Map) {
        return PatientModel.fromJson(raw.cast<String, dynamic>());
      }
      return null;
    } catch (e, st) {
      AppLogger.instance.e('getPatientData failed', e, st);
      return null;
    }
  }

  Future<void> savePatientData(PatientModel patient) async {
    final box = await boxManager.openBox(_userBox);
    await box.put(_patientDataKey, patient.toJson());
    await box.delete(_doctorDataKey);
  }

  Future<DoctorModel?> getDoctorData() async {
    try {
      final box = await boxManager.openBox(_userBox);
      final raw = box.get(_doctorDataKey);
      if (raw is DoctorModel) return raw;
      if (raw is Map) {
        return DoctorModel.fromJson(raw.cast<String, dynamic>());
      }
      return null;
    } catch (e, st) {
      AppLogger.instance.e('getDoctorData failed', e, st);
      return null;
    }
  }

  Future<void> saveDoctorData(DoctorModel doctor) async {
    final box = await boxManager.openBox(_userBox);
    await box.put(_doctorDataKey, doctor.toJson());
    await box.delete(_patientDataKey);
  }

  Future<void> saveUserProfile({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? country,
    String? dateOfBirth,
    String? gender,
    String? profileImage,
  }) async {
    final settingsBox = await boxManager.openBox(_settingsBox);
    if (country != null) {
      await settingsBox.put(_userCountryKey, country);
    }

    final currentUser = await getUserData();
    if (currentUser == null) return;

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

  Future<Map<String, String?>> getUserProfile() async {
    final user = await getUserData();
    if (user == null) return {};
    String? country;
    try {
      final settingsBox = await boxManager.openBox(_settingsBox);
      country = settingsBox.get(_userCountryKey) as String?;
    } catch (e, st) {
      AppLogger.instance.e('getUserProfile country lookup failed', e, st);
    }

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

  Future<String?> getEmail() async {
    final user = await getUserData();
    return user?.email;
  }

  Future<bool> isTwoFactorEnabled() async {
    final user = await getUserData();
    return user?.twoFA ?? false;
  }

  Future<void> setTwoFactorEnabled(bool enabled) async {
    final currentUser = await getUserData();
    if (currentUser != null) {
      final updatedUser = UserModel(
        id: currentUser.id,
        type: currentUser.type,
        firstName: currentUser.firstName,
        lastName: currentUser.lastName,
        email: currentUser.email,
        gender: currentUser.gender,
        twoFA: enabled,
        profilePicture: currentUser.profilePicture,
        confirmed: currentUser.confirmed,
      );
      await saveUserData(updatedUser);
    }
  }
}
