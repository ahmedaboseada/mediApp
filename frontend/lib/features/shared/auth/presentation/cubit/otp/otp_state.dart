part of 'otp_cubit.dart';

@immutable
sealed class OtpState {}

final class OtpInitial extends OtpState {}

final class OtpLoading extends OtpState {}

final class OtpSuccess extends OtpState {
  final String message;
  final String otp;
  OtpSuccess(this.message, this.otp);
}

final class OtpFailure extends OtpState {
  final String error;
  OtpFailure(this.error);
}

final class ResendOtpLoading extends OtpState {}

final class ResendOtpSuccess extends OtpState {
  final String message;
  ResendOtpSuccess(this.message);
}

final class Otp2FASuccess extends OtpState {
  final String message;
  final UserRole role;
  Otp2FASuccess(this.message, this.role);
}
