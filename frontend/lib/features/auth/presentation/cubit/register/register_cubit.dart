import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/enums/user_role.dart';
import 'package:medi/features/auth/data/repo/auth_repo.dart';
import 'package:meta/meta.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepo authRepo;
  RegisterCubit(this.authRepo) : super(RegisterInitial());
  Future<void> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String firstName,
    required String lastName,
    required UserRole role,
  }) async {
    emit(RegisterLoading());
    final result = await authRepo.signUpWithEmailAndPassword(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      firstName: firstName,

      lastName: lastName,
      role: role,
    );
    result.fold(
      (failure) => emit(RegisterFailure(failure.message)),
      (response) => emit(RegisterSuccess(role, response.message)),
    );
  }
}
