import 'package:hive_flutter/hive_flutter.dart';
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

  UserLocalDataSource({HiveBoxManager? boxManager}) : boxManager = boxManager ?? const HiveBoxManager();

  UserModel? getUserData() {
    if (!Hive.isBoxOpen(_userBox)) return null;
    try {
      return Hive.box(_userBox).get(_userDataKey) as UserModel?;
    } catch (_) {
      Hive.box(_userBox).delete(_userDataKey);
      return null;
    }
  }

  Future<void> saveUserData(UserModel user) async {
    try {
      final box = await boxManager.openBox(_userBox);
      await box.put(_userDataKey, user);
    } catch (e, st) {
      AppLogger.instance.e('saveUserData failed', e, st);
    }
  }

  PatientModel? getPatientData() {
    if (!Hive.isBoxOpen(_userBox)) return null;
    try {
      return Hive.box(_userBox).get(_patientDataKey) as PatientModel?;
    } catch (_) {
      Hive.box(_userBox).delete(_patientDataKey);
      return null;
    }
  }

  Future<void> savePatientData(PatientModel patient) async {
    final box = await boxManager.openBox(_userBox);
    await box.put(_patientDataKey, patient);
    await box.delete(_doctorDataKey);
  }

  DoctorModel? getDoctorData() {
    if (!Hive.isBoxOpen(_userBox)) return null;
    try {
      return Hive.box(_userBox).get(_doctorDataKey) as DoctorModel?;
    } catch (_) {
      Hive.box(_userBox).delete(_doctorDataKey);
      return null;
    }
  }

  Future<void> saveDoctorData(DoctorModel doctor) async {
    final box = await boxManager.openBox(_userBox);
    await box.put(_doctorDataKey, doctor);
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

    final currentUser = getUserData();
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

  Map<String, String?> getUserProfile() {
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

  String? getEmail() {
    final user = getUserData();
    return user?.email;
  }

  bool isTwoFactorEnabled() {
    final user = getUserData();
    return user?.twoFA ?? false;
  }

  Future<void> setTwoFactorEnabled(bool enabled) async {
    final currentUser = getUserData();
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
