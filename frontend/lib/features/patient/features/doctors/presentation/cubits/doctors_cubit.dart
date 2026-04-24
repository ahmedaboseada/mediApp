import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/patient/features/doctors/data/repo/doctors_repo.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/doctors_state.dart';

class DoctorsCubit extends Cubit<DoctorsState> {
  final DoctorsRepository repository;

  DoctorsCubit({required this.repository}) : super(DoctorsInitial());

  Future<void> loadDoctors() async {
    emit(DoctorsLoading());

    final result = await repository.getGlobalDoctors();
    
    if (isClosed) return;

    result.fold(
      (failure) => emit(DoctorsError(failure.message)),
      (doctors) => emit(DoctorsLoaded(doctors)),
    );
  }
}
