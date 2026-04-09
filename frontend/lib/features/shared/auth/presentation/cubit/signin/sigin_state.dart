part of 'sigin_cubit.dart';

@immutable
sealed class SiginState {}

final class SiginInitial extends SiginState {}

final class SiginLoading extends SiginState {}

final class SiginSuccess extends SiginState {
  final UserRole role;
  SiginSuccess(this.role);
}

final class Signin2FARequired extends SiginState {
  final String challengeToken;
  final String email;
  final UserRole role;
  Signin2FARequired({
    required this.challengeToken,
    required this.email,
    required this.role,
  });
}

final class SiginFailure extends SiginState {
  final String error;
  SiginFailure(this.error);
}
