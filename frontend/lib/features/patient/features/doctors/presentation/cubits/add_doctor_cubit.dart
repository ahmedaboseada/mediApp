import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/patient/features/doctors/data/repo/doctors_repo.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/add_doctor_state.dart';

class AddDoctorCubit extends Cubit<AddDoctorState> {
  AddDoctorCubit(this._repository) : super(const AddDoctorState());

  final DoctorsRepository _repository;

  Future<void> sendAddRequest(String doctorId) async {
    emit(state.copyWith(status: AddDoctorStatus.loading, clearError: true));

    final result = await _repository.sendConnectionRequest(doctorId);

    result.fold(
      (error) {
        emit(
          state.copyWith(
            status: AddDoctorStatus.failure,
            errorMessage: error.message,
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(status: AddDoctorStatus.success, clearError: true),
        );
      },
    );
  }

  void resetState() {
    emit(const AddDoctorState());
  }
}
