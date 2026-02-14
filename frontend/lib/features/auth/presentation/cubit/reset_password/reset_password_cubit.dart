import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/auth/data/repo/auth_repo.dart';
import 'package:meta/meta.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final AuthRepo authRepo;
  ResetPasswordCubit(this.authRepo) : super(ResetPasswordInitial());
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    emit(ResetPasswordLoading());
    try {
      final message = await authRepo.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );
      message.fold(
        (failure) => failure.message,
        (message) => emit(ResetPasswordSuccess(message)),
      );
    } catch (e) {
      emit(ResetPasswordFailure(e.toString()));
    }
  }
}
