part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ChangePasswordLoading extends ProfileState {}

final class ChangePasswordSuccess extends ProfileState {
  final String message;

  ChangePasswordSuccess(this.message);
}

final class ChangePasswordFailure extends ProfileState {
  final String message;
  final List<String> errors;

  ChangePasswordFailure(this.message, [this.errors = const []]);
}

final class RequestEmailChangeLoading extends ProfileState {}

final class RequestEmailChangeSuccess extends ProfileState {
  final String message;

  RequestEmailChangeSuccess(this.message);
}

final class RequestEmailChangeFailure extends ProfileState {
  final String message;
  final List<String> errors;

  RequestEmailChangeFailure(this.message, [this.errors = const []]);
}

final class CancelEmailChangeLoading extends ProfileState {}

final class CancelEmailChangeSuccess extends ProfileState {
  final String message;

  CancelEmailChangeSuccess(this.message);
}

final class CancelEmailChangeFailure extends ProfileState {
  final String message;
  final List<String> errors;

  CancelEmailChangeFailure(this.message, [this.errors = const []]);
}

final class ConfirmEmailChangeLoading extends ProfileState {}

final class ConfirmEmailChangeSuccess extends ProfileState {
  final String message;

  ConfirmEmailChangeSuccess(this.message);
}

final class ConfirmEmailChangeFailure extends ProfileState {
  final String message;
  final List<String> errors;

  ConfirmEmailChangeFailure(this.message, [this.errors = const []]);
}

final class ToggleTwoFactorAuthLoading extends ProfileState {}

final class ToggleTwoFactorAuthSuccess extends ProfileState {
  final String message;

  ToggleTwoFactorAuthSuccess(this.message);
}

final class ToggleTwoFactorAuthFailure extends ProfileState {
  final String message;
  final List<String> errors;

  ToggleTwoFactorAuthFailure(this.message, [this.errors = const []]);
}

final class CaregiverRequestsLoading extends ProfileState {}

final class CaregiverRequestsSuccess extends ProfileState {
  final List<CaregiverRequestModel> requests;

  CaregiverRequestsSuccess(this.requests);
}

final class CaregiverRequestsFailure extends ProfileState {
  final String message;
  final List<String> errors;

  CaregiverRequestsFailure(this.message, [this.errors = const []]);
}

final class CaregiverRequestActionLoading extends ProfileState {}

final class CaregiverRequestActionSuccess extends ProfileState {
  final String message;

  CaregiverRequestActionSuccess(this.message);
}

final class CaregiverRequestActionFailure extends ProfileState {
  final String message;
  final List<String> errors;

  CaregiverRequestActionFailure(this.message, [this.errors = const []]);
}

final class DoctorRequestsLoading extends ProfileState {}

final class DoctorRequestsSuccess extends ProfileState {
  final List<DoctorRequestModel> requests;

  DoctorRequestsSuccess(this.requests);
}

final class DoctorRequestsFailure extends ProfileState {
  final String message;
  final List<String> errors;

  DoctorRequestsFailure(this.message, [this.errors = const []]);
}

final class DoctorRequestActionLoading extends ProfileState {}

final class DoctorRequestActionSuccess extends ProfileState {
  final String message;

  DoctorRequestActionSuccess(this.message);
}

final class DoctorRequestActionFailure extends ProfileState {
  final String message;
  final List<String> errors;

  DoctorRequestActionFailure(this.message, [this.errors = const []]);
}
