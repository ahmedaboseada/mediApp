import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/doctor/features/patients/data/repo/patients_repository.dart';
import 'package:medi/features/doctor/features/patients/presentation/cubit/add_patient/add_patient_state.dart';

class AddPatientCubit extends Cubit<AddPatientState> {
  AddPatientCubit(this._repository) : super(const AddPatientState());

  final PatientsRepository _repository;

  Future<void> sendAddRequest(String patientId) async {
    emit(state.copyWith(status: AddPatientStatus.loading, clearError: true));

    final result = await _repository.sendAddRequest(patientId);

    result.fold(
      (error) {
        emit(
          state.copyWith(
            status: AddPatientStatus.failure,
            errorMessage: error.message,
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(status: AddPatientStatus.success, clearError: true),
        );
      },
    );
  }

  void resetState() {
    emit(const AddPatientState());
  }
}
