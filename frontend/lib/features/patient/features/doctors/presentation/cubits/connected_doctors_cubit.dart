import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/patient/features/doctors/data/repo/doctors_repo.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/connected_doctors_state.dart';

class ConnectedDoctorsCubit extends Cubit<ConnectedDoctorsState> {
  final DoctorsRepository repository;

  ConnectedDoctorsCubit({required this.repository}) : super(ConnectedDoctorsInitial());

  Future<void> loadConnectedDoctors() async {
    emit(ConnectedDoctorsLoading());

    final result = await repository.getConnectedDoctors();

    if (isClosed) return;

    result.fold(
      (failure) => emit(ConnectedDoctorsError(failure.message)),
      (doctors) => emit(ConnectedDoctorsLoaded(doctors)),
    );
  }
}
