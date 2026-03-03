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
