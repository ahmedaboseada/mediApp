import 'package:medi/core/enums/user_role.dart';

class HiveKeys {
  static String medications({required UserRole role, required String userId}) {
    final roleLabel = role == UserRole.doctor ? 'doctor' : 'patient';
    return 'medications/$roleLabel/$userId';
  }

  static String schedule({required UserRole role, required String userId, required String date}) {
    final roleLabel = role == UserRole.doctor ? 'doctor' : 'patient';
    final normalizedDate = date.trim().isEmpty ? 'all' : date.trim();
    return 'schedule/$roleLabel/$userId/$normalizedDate';
  }

  static String scheduleUnscoped(String date) {
    final normalizedDate = date.trim().isEmpty ? 'all' : date.trim();
    return 'schedule/$normalizedDate';
  }
}
