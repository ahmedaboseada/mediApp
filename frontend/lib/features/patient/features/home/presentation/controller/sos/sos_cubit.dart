import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/patient/features/home/data/repo/sos_repo.dart';

part 'sos_state.dart';

class SosCubit extends Cubit<SosState> {
  final SosRepo sosRepo;

  SosCubit(this.sosRepo) : super(const SosInitial());

  Future<void> setEmergencyContact({
    required String name,
    required String phone,
    required String contactMethod,
  }) async {
    emit(const SosLoading());

    final result = await sosRepo.setEmergencyContact(
      name: name,
      phone: phone,
      contactMethod: contactMethod,
    );

    result.fold(
      (failure) => emit(SosFailure(message: failure.message)),
      (message) => emit(
        EmergencyContactSetSuccess(
          message: message,
          contactName: name,
          contactMethod: contactMethod,
        ),
      ),
    );
  }

  Future<void> triggerSos() async {
    emit(const SosLoading());

    final result = await sosRepo.triggerSos();

    result.fold(
      (failure) => emit(SosFailure(message: failure.message)),
      (message) => emit(SosTriggeredSuccess(message: message)),
    );
  }
}
