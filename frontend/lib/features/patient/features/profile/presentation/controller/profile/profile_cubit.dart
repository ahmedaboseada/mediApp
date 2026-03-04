import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/patient/features/profile/data/repo/profile_repo.dart';
import 'package:meta/meta.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;

  ProfileCubit(this.profileRepo) : super(ProfileInitial());

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(ChangePasswordLoading());
    
    final result = await profileRepo.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    result.fold(
      (failure) => emit(ChangePasswordFailure(failure.message, failure.errors)),
      (message) => emit(ChangePasswordSuccess(message)),
    );
  }

  Future<void> requestEmailChange({
    required String newEmail,
  }) async {
    emit(RequestEmailChangeLoading());
    
    final result = await profileRepo.requestEmailChange(
      newEmail: newEmail,
    );

    result.fold(
      (failure) => emit(RequestEmailChangeFailure(failure.message, failure.errors)),
      (message) => emit(RequestEmailChangeSuccess(message)),
    );
  }

  Future<void> cancelEmailChange() async {
    emit(CancelEmailChangeLoading());
    
    final result = await profileRepo.cancelEmailChange();

    result.fold(
      (failure) => emit(CancelEmailChangeFailure(failure.message, failure.errors)),
      (message) => emit(CancelEmailChangeSuccess(message)),
    );
  }

  Future<void> confirmEmailChange({
    required String confirmEmailChangeToken,
  }) async {
    emit(ConfirmEmailChangeLoading());
    
    final result = await profileRepo.confirmEmailChange(
      confirmEmailChangeToken: confirmEmailChangeToken,
    );

    result.fold(
      (failure) => emit(ConfirmEmailChangeFailure(failure.message, failure.errors)),
      (message) => emit(ConfirmEmailChangeSuccess(message)),
    );
  }

  Future<void> toggleTwoFactorAuth(bool enabled) async {
    emit(ToggleTwoFactorAuthLoading());
    
    final result = await profileRepo.toggleTwoFactorAuth(enabled);

    result.fold(
      (failure) => emit(ToggleTwoFactorAuthFailure(failure.message, failure.errors)),
      (message) => emit(ToggleTwoFactorAuthSuccess(message)),
    );
  }
}
