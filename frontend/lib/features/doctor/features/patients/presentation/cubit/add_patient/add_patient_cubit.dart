import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/doctor/features/patients/data/repo/patients_repository.dart';
import 'package:medi/features/doctor/features/patients/presentation/cubit/add_patient/add_patient_state.dart';

class AddPatientCubit extends Cubit<AddPatientState> {
  AddPatientCubit(this._repository) : super(const AddPatientState());

  final PatientsRepository _repository;

  Future<void> sendAddRequest(String patientId, {String? recipientFcmToken}) async {
    emit(
      state.copyWith(
        status: AddPatientStatus.loading,
        lastAction: AddPatientAction.sendRequest,
        clearError: true,
      ),
    );

    final result = await _repository.sendAddRequest(
      patientId,
      recipientFcmToken: recipientFcmToken,
    );

    result.fold(
      (error) {
        emit(
          state.copyWith(
            status: AddPatientStatus.failure,
            lastAction: AddPatientAction.sendRequest,
            errorMessage: error.message,
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
            status: AddPatientStatus.success,
            lastAction: AddPatientAction.sendRequest,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> cancelPatientRequest(String patientId) async {
    emit(
      state.copyWith(
        status: AddPatientStatus.loading,
        lastAction: AddPatientAction.cancelRequest,
        clearError: true,
      ),
    );

    final result = await _repository.cancelPatientRequest(patientId);

    result.fold(
      (error) {
        emit(
          state.copyWith(
            status: AddPatientStatus.failure,
            lastAction: AddPatientAction.cancelRequest,
            errorMessage: error.message,
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
            status: AddPatientStatus.success,
            lastAction: AddPatientAction.cancelRequest,
            clearError: true,
          ),
        );
      },
    );
  }

  void resetState() {
    emit(const AddPatientState());
  }
}
