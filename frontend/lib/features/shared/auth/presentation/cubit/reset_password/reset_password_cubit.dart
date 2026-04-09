import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/shared/auth/data/repo/auth_repo.dart';
import 'package:meta/meta.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final AuthRepo authRepo;
  ResetPasswordCubit(this.authRepo) : super(ResetPasswordInitial());
  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(ResetPasswordLoading());
    try {
      final message = await authRepo.resetPassword(
        resetToken: resetToken,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      message.fold(
        (failure) => emit(ResetPasswordFailure(failure.message)),
        (message) => emit(ResetPasswordSuccess(message)),
      );
    } catch (e) {
      emit(ResetPasswordFailure(e.toString()));
    }
  }
}
