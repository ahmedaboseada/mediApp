import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/enums/user_role.dart';
import 'package:medi/features/shared/auth/data/repo/auth_repo.dart';

part 'sigin_state.dart';

class SiginCubit extends Cubit<SiginState> {
  SiginCubit(this.authRepo) : super(SiginInitial());
  final AuthRepo authRepo;
  Future<void> signin(String email, String password, UserRole role) async {
    emit(SiginLoading());
    var result = await authRepo.signInWithEmailAndPassword(
      email: email,
      password: password,
      role: role,
    );
    result.fold((failure) => emit(SiginFailure(failure.message)), (tokens) {
      emit(SiginSuccess(role));
    });
  }

  Future<void> signout() async {
    try {
      emit(SiginLoading());
      // Add signout logic here
      emit(SiginInitial());
    } catch (e) {
      emit(SiginFailure(e.toString()));
    }
  }
}
