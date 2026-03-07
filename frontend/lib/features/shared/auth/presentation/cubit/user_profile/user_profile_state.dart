import 'package:medi/features/shared/auth/data/models/auth_response_model.dart';

abstract class UserProfileState {
  const UserProfileState();
}

class UserProfileInitial extends UserProfileState {
  const UserProfileInitial();
}

class UserProfileLoading extends UserProfileState {
  const UserProfileLoading();
}

class UserProfileLoaded extends UserProfileState {
  final AuthResponseModel profile;

  const UserProfileLoaded(this.profile);
}

class UserProfileError extends UserProfileState {
  final String message;

  const UserProfileError(this.message);
}
class UserProfileUpdated extends UserProfileState {
  final AuthResponseModel profile;

  const UserProfileUpdated(this.profile);
}