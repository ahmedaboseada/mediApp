import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/shared/auth/data/repo/auth_repo.dart';
import 'package:meta/meta.dart';

part 'log_out_state.dart';

class LogOutCubit extends Cubit<LogOutState> {
  final AuthRepo authRepo;
  LogOutCubit(this.authRepo) : super(LogOutInitial());
  Future<void> logOut() async {
    emit(LogOutLoading());
    try {
      await authRepo.signOut();
      emit(LogOutSuccess());
    } catch (e) {
      emit(LogOutFailure(e.toString()));
    }
  }
}
