enum UserRole { doctor, patient }

extension UserRoleExtension on UserRole {
  String get routeName {
    switch (this) {
      case UserRole.doctor:
        return 'doctor';
      case UserRole.patient:
        return 'patient';
    }
  }

  String get title {
    switch (this) {
      case UserRole.doctor:
        return 'Doctor';
      case UserRole.patient:
        return 'Patient';
    }
  }
}
