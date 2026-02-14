part of 'google_log_in_cubit.dart';

@immutable
sealed class GoogleLogInState {}

final class GoogleLogInInitial extends GoogleLogInState {}

final class GoogleLogInLoading extends GoogleLogInState {}

final class GoogleLogInSuccess extends GoogleLogInState {}

final class GoogleLogInFailure extends GoogleLogInState {
  final String error;
  GoogleLogInFailure(this.error);
}
