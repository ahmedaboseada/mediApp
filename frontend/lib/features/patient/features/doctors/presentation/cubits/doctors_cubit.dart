import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/patient/features/doctors/data/models/doctor_summary.dart';
import 'package:medi/features/patient/features/doctors/data/repo/doctors_repo.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/doctors_state.dart';

class DoctorsCubit extends Cubit<DoctorsState> {
  final DoctorsRepository repository;

  DoctorsCubit({required this.repository}) : super(DoctorsInitial());
  List<Doctordata> _allDoctors = [];
  Future<void> loadDoctors() async {
    final cachedDoctors = await repository.getCachedGlobalDoctors();

    if (isClosed) return;

    if (cachedDoctors.isNotEmpty) {
      _allDoctors = cachedDoctors;
      emit(DoctorsLoaded(cachedDoctors));
    } else {
      emit(DoctorsLoading());
    }

    final result = await repository.getGlobalDoctors();

    if (isClosed) return;

    result.fold(
      (failure) {
        if (cachedDoctors.isEmpty) {
          emit(DoctorsError(failure.message));
        }
      },
      (doctors) {
        _allDoctors = doctors;
        emit(DoctorsLoaded(doctors));
      },
    );
  }

  void searchDoctors(String query) {
    if (query.isEmpty) {
      emit(DoctorsLoaded(_allDoctors));
      return;
    }

    final filteredDoctors = _allDoctors.where((doctor) {
      final nameMatch =
          doctor.user.firstName.toLowerCase().contains(query.toLowerCase()) ||
          doctor.user.lastName.toLowerCase().contains(query.toLowerCase());

      final specialtyMatch = doctor.specialization.toLowerCase().contains(
        query.toLowerCase(),
      );

      return nameMatch || specialtyMatch;
    }).toList();

    emit(DoctorsLoaded(filteredDoctors));
  }

  void clearSearch() {
    emit(DoctorsLoaded(_allDoctors));
  }
}
