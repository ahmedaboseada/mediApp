import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/shared/auth/data/repo/auth_repo.dart';
import 'package:meta/meta.dart';
part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final AuthRepo authRepo;
  String otp = '';
  String? resetToken; 

  OtpCubit(this.authRepo) : super(OtpInitial());
  void onOtpChanged(String value) {
    otp = value;
  }

  Future<void> verifyOtp(String email) async {
    emit(OtpLoading());
    try {
      final result = await authRepo.verifyOtp(email: email, otp: otp);
      result.fold(
        (failure) => emit(OtpFailure(failure.message)),
        (data) {
          resetToken = data.resetToken;
          emit(OtpSuccess(data.message, otp));
        },
      );
    } catch (e) {
      emit(OtpFailure(e.toString()));
    }
  }

  Future<void> resendOtp(String email) async {
    emit(ResendOtpLoading());
    try {
      final result = await authRepo.resendOtp(email: email);
      result.fold(
        (failure) => emit(OtpFailure(failure.message)),
        (message) => emit(ResendOtpSuccess(message)),
      );
    } catch (e) {
      emit(OtpFailure(e.toString()));
    }
  }
}
