import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/patient/features/doctors/data/repo/doctors_repo.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/connected_doctors_state.dart';

class ConnectedDoctorsCubit extends Cubit<ConnectedDoctorsState> {
  final DoctorsRepository repository;

  ConnectedDoctorsCubit({required this.repository})
    : super(ConnectedDoctorsInitial());

  Future<void> loadConnectedDoctors() async {
    final cachedDoctors = await repository.getCachedConnectedDoctors();

    if (isClosed) return;

    if (cachedDoctors.isNotEmpty) {
      emit(ConnectedDoctorsLoaded(cachedDoctors));
    } else {
      emit(ConnectedDoctorsLoading());
    }

    final result = await repository.getConnectedDoctors();

    if (isClosed) return;

    result.fold(
      (failure) {
        if (cachedDoctors.isEmpty) {
          emit(ConnectedDoctorsError(failure.message));
        }
      },
      (doctors) => emit(ConnectedDoctorsLoaded(doctors)),
    );
  }
}
