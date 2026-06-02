import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/patient/features/doctors/data/repo/doctors_repo.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/add_doctor_state.dart';

class AddDoctorCubit extends Cubit<AddDoctorState> {
  AddDoctorCubit(this._repository) : super(const AddDoctorState());

  final DoctorsRepository _repository;

  Future<void> sendAddRequest(String doctorId, {String? recipientFcmToken}) async {
    emit(
      state.copyWith(
        status: AddDoctorStatus.loading,
        lastAction: AddDoctorAction.sendRequest,
        clearError: true,
      ),
    );

    final result = await _repository.sendConnectionRequest(
      doctorId,
      recipientFcmToken: recipientFcmToken,
    );

    result.fold(
      (error) {
        emit(
          state.copyWith(
            status: AddDoctorStatus.failure,
            lastAction: AddDoctorAction.sendRequest,
            errorMessage: error.message,
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
            status: AddDoctorStatus.success,
            lastAction: AddDoctorAction.sendRequest,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> cancelConnectionRequest(String doctorId) async {
    emit(
      state.copyWith(
        status: AddDoctorStatus.loading,
        lastAction: AddDoctorAction.cancelRequest,
        clearError: true,
      ),
    );

    final result = await _repository.cancelConnectionRequest(doctorId);

    result.fold(
      (error) {
        emit(
          state.copyWith(
            status: AddDoctorStatus.failure,
            lastAction: AddDoctorAction.cancelRequest,
            errorMessage: error.message,
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
            status: AddDoctorStatus.success,
            lastAction: AddDoctorAction.cancelRequest,
            clearError: true,
          ),
        );
      },
    );
  }

  void resetState() {
    emit(const AddDoctorState());
  }
}
