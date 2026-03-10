import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/shared/auth/data/repo/auth_repo.dart';
import 'package:meta/meta.dart';

part 'google_log_in_state.dart';

class GoogleLogInCubit extends Cubit<GoogleLogInState> {
  GoogleLogInCubit(this.authRepo) : super(GoogleLogInInitial());
  final AuthRepo authRepo;
  Future<void> logInWithGoogle({required UserRole userType}) async {
    emit(GoogleLogInLoading());
    try {
      final result = await authRepo.signInWithGoogle(userType: userType);
      result.fold(
        (failure) => emit(GoogleLogInFailure(failure.message)),
        (tokens) => emit(GoogleLogInSuccess()),
      );
    } catch (e) {
      emit(GoogleLogInFailure(e.toString()));
    }
  }
}
