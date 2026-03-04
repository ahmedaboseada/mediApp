import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/shared/auth/data/repo/auth_repo.dart';
import 'package:medi/features/shared/auth/presentation/cubit/complete_profile/complete_profile_state.dart';

class CompleteProfileCubit extends Cubit<CompleteProfileState> {
  final AuthRepo authRepo;

  CompleteProfileCubit(this.authRepo) : super(CompleteProfileInitial());

  Future<void> completeBasicProfile({
    required String phone,
    required int yearOfBirth,
    required String gender,
    String? profilePicture,
  }) async {
    emit(CompleteProfileLoading());

    final result = await authRepo.completeBasicProfile(
      phone: phone,
      yearOfBirth: yearOfBirth,
      gender: gender,
      profilePicture: profilePicture,
    );

    result.fold(
      (failure) => emit(CompleteProfileFailure(failure.message)),
      (message) => emit(CompleteProfileSuccess(message)),
    );
  }
}

