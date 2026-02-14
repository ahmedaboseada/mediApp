import 'package:medi/features/auth/data/repo/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  AuthRepo authRepo;
  ForgetPasswordCubit(this.authRepo) : super(ForgetPasswordInitial());
  Future<void> submitForgetPassword(String email) async {
    emit(ForgetPasswordLoading());
    try {
      final result = await authRepo.forgetPassword(email: email);
      result.fold(
        (failure) => emit(ForgetPasswordFailure(failure.message)),
        (message) => emit(ForgetPasswordSuccess(message)),
      );
    } catch (e) {
      emit(ForgetPasswordFailure(e.toString()));
    }
  }
}
