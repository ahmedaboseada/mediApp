import 'package:meta/meta.dart';

@immutable
sealed class DoctorCompleteProfileState {}

final class DoctorCompleteProfileInitial extends DoctorCompleteProfileState {}

final class DoctorCompleteProfileLoading extends DoctorCompleteProfileState {}

final class DoctorCompleteProfileSuccess extends DoctorCompleteProfileState {
  DoctorCompleteProfileSuccess(this.message);
  final String message;
}

final class DoctorCompleteProfileFailure extends DoctorCompleteProfileState {
  DoctorCompleteProfileFailure(this.error);
  final String error;
}
