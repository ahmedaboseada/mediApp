import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/patient/features/profile/data/repo/profile_repo.dart';
import 'health_report_export_state.dart';

class HealthReportExportCubit extends Cubit<HealthReportExportState> {
  final ProfileRepo profileRepo;

  HealthReportExportCubit(this.profileRepo) : super(HealthReportExportInitial());

  Future<void> exportHealthReport({required String apiEndpoint}) async {
    emit(HealthReportExportLoading());

    final result = await profileRepo.exportHealthPassportPDF(apiEndpoint: apiEndpoint);

    result.fold(
      (failure) => emit(HealthReportExportFailure(failure.message)),
      (filePath) => emit(HealthReportExportSuccess(filePath)),
    );
  }
}
