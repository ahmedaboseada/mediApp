import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/doctor/features/patients/data/repo/patients_repository.dart';
import 'package:medi/features/doctor/features/patients/presentation/cubit/patients_state.dart';

class PatientsCubit extends Cubit<PatientsState> {
  PatientsCubit(this._repository) : super(const PatientsState());

  final PatientsRepository _repository;

  Future<void> loadPatients() async {
    emit(state.copyWith(status: PatientsStatus.loading, clearError: true));

    final result = await _repository.getPatients();

    result.fold(
      (error) {
        emit(
          state.copyWith(
            status: PatientsStatus.failure,
            errorMessage: error.message,
          ),
        );
      },
      (patients) {
        emit(
          state.copyWith(
            status: patients.isEmpty
                ? PatientsStatus.empty
                : PatientsStatus.success,
            patients: patients,
            filteredPatients: patients,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> searchPatients(String query) async {
    // Update the search query first
    emit(state.copyWith(searchQuery: query));

    if (query.isEmpty) {
      // Show all patients if query is empty
      emit(
        state.copyWith(
          filteredPatients: state.patients,
          status: state.patients.isEmpty
              ? PatientsStatus.empty
              : PatientsStatus.success,
        ),
      );
      return;
    }

    // Search in the repository with the query
    emit(state.copyWith(status: PatientsStatus.loading));

    final result = await _repository.getPatients(searchQuery: query);

    result.fold(
      (error) {
        emit(
          state.copyWith(
            status: PatientsStatus.failure,
            errorMessage: error.message,
          ),
        );
      },
      (filteredPatients) {
        emit(
          state.copyWith(
            status: filteredPatients.isEmpty
                ? PatientsStatus.empty
                : PatientsStatus.success,
            filteredPatients: filteredPatients,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> retry() async {
    if (state.searchQuery.isEmpty) {
      await loadPatients();
    } else {
      await searchPatients(state.searchQuery);
    }
  }

  void clearSearch() {
    emit(
      state.copyWith(
        searchQuery: '',
        filteredPatients: state.patients,
        status: state.patients.isEmpty
            ? PatientsStatus.empty
            : PatientsStatus.success,
      ),
    );
  }
}
