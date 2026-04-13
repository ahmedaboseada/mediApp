import 'package:meta/meta.dart';

@immutable
sealed class CompleteProfileState {}

final class CompleteProfileInitial extends CompleteProfileState {}

final class CompleteProfileLoading extends CompleteProfileState {}

final class CompleteProfileSuccess extends CompleteProfileState {
  final String message;
  CompleteProfileSuccess(this.message);
}

final class CompleteProfileFailure extends CompleteProfileState {
  final String error;
  CompleteProfileFailure(this.error);
}
