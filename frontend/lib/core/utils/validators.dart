import 'package:medi/core/constants/app_strings.dart';

extension AppValidators on String? {
  String? validateRequired(String message) {
    if (this == null || this!.isEmpty) {
      return message;
    }
    return null;
  }

  String? validateAge() {
    if (this == null || this!.isEmpty) {
      return AppStrings.ageEmpty;
    }
    final age = int.tryParse(this!);
    if (age == null || age < 0 || age > 120) {
      return AppStrings.ageInvalid;
    }
    return null;
  }

  String? validateEmail() {
    if (this == null || this!.isEmpty) {
      return AppStrings.emailEmpty;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(this!)) {
      return AppStrings.emailInvalid;
    }
    return null;
  }

  String? validatePassword() {
    if (this == null || this!.isEmpty) {
      return AppStrings.passwordEmpty;
    }
    if (this!.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'[A-Z]').hasMatch(this!)) {
      return 'Password must contain an uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(this!)) {
      return 'Password must contain a lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(this!)) {
      return 'Password must contain a number';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(this!)) {
      return 'Password must contain a special character';
    }
    return null;
  }

  String? validateConfirmPassword(String password) {
    if (this == null || this!.isEmpty) {
      return AppStrings.confirmPasswordEmpty;
    }
    if (this != password) {
      return AppStrings.passwordsDoNotMatch;
    }
    return null;
  }

  String? validateConfirmEmail(String email) {
    if (this == null || this!.isEmpty) {
      return 'Confirm email is required';
    }
    if (this != email) {
      return 'Emails do not match';
    }
    return null;
  }

  String? validateFirstName() {
    if (this == null || this!.isEmpty) {
      return AppStrings.firstNameEmpty;
    }
    if (this!.length < 2) {
      return AppStrings.firstNameTooShort;
    }
    return null;
  }

  String? validateLastName() {
    if (this == null || this!.isEmpty) {
      return AppStrings.lastNameEmpty;
    }
    if (this!.length < 2) {
      return AppStrings.lastNameTooShort;
    }
    return null;
  }

  String? validatePhone() {
    if (this == null || this!.isEmpty) {
      return AppStrings.phoneEmpty;
    }
    if (!RegExp(r'^01[0125][0-9]{8}$').hasMatch(this!)) {
      return AppStrings.phoneInvalid;
    }
    return null;
  }

  String? validateClinicName() {
    if (this == null || this!.isEmpty) {
      return 'Clinic/Hospital name is required';
    }
    if (this!.trim().length < 2) {
      return 'Clinic/Hospital name is too short';
    }
    return null;
  }

  String? validateMedicalLicense() {
    if (this == null || this!.isEmpty) {
      return 'Medical license number is required';
    }
    if (this!.trim().length < 3) {
      return 'Medical license number is too short';
    }
    return null;
  }
}
