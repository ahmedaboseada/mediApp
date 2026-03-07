import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/shared/auth/data/repo/auth_repo.dart';
import 'package:medi/features/shared/auth/presentation/cubit/user_profile/user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit(this._authRepo) : super(const UserProfileInitial());

  final AuthRepo _authRepo;

  Future<void> getMe() async {
    emit(const UserProfileLoading());

    final result = await _authRepo.getMe();

    result.fold(
      (error) => emit(UserProfileError(error.message)),
      (profile) => emit(UserProfileLoaded(profile)),
    );
  }

  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? gender,
    String? profilePicture,
    String? specialization,
    String? clinicName,
    String? medicalLicenseId,
  }) async {
    emit(const UserProfileLoading());

    final result = await _authRepo.updateProfile(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      gender: gender,
      profilePicture: profilePicture,
      specialization: specialization,
      clinicName: clinicName,
      medicalLicenseId: medicalLicenseId,
    );

    result.fold(
      (error) => emit(UserProfileError(error.message)),
      (profile) => emit(UserProfileUpdated(profile)),
    );
  }
}
