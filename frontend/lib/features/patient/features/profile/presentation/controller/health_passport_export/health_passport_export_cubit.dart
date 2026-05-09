import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/patient/features/profile/data/repo/profile_repo.dart';
import 'package:medi/features/patient/features/profile/presentation/controller/health_passport_export/health_passport_export_state.dart';

class HealthPassportExportCubit extends Cubit<HealthPassportExportState> {
  final ProfileRepo profileRepo;

  HealthPassportExportCubit(this.profileRepo)
      : super(HealthPassportExportInitial());

  Future<void> exportHealthPassport({
    required String apiEndpoint,
  }) async {
    emit(HealthPassportExportLoading());

    final result = await profileRepo.exportHealthPassportPDF(
      apiEndpoint: apiEndpoint,
    );

    result.fold(
      (failure) => emit(HealthPassportExportFailure(failure.message)),
      (filePath) => emit(HealthPassportExportSuccess(filePath)),
    );
  }
}
