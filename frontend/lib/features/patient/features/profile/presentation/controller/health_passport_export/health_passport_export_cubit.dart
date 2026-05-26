import 'dart:developer';
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

class QRTokenCubit extends Cubit<QRTokenState> {
  final ProfileRepo profileRepo;

  QRTokenCubit(this.profileRepo) : super(QRTokenInitial());

  Future<void> generateQRToken() async {
    emit(QRTokenLoading());

    final result = await profileRepo.generateQRToken();
    
    result.fold(
      (failure) => emit(QRTokenFailure(failure.message)),
      (qrToken) {
        log('QR Token generated: $qrToken');
        emit(QRTokenSuccess(qrToken));
      },
    );
  }
}

class SharedRecordDownloadCubit extends Cubit<SharedRecordDownloadState> {
  final ProfileRepo profileRepo;

  SharedRecordDownloadCubit(this.profileRepo)
      : super(SharedRecordDownloadInitial());

  Future<void> downloadSharedRecord(String qrToken) async {
    emit(SharedRecordDownloadLoading());

    final result = await profileRepo.downloadSharedRecord(
      qrToken: qrToken,
    );

    result.fold(
      (failure) => emit(SharedRecordDownloadFailure(failure.message)),
      (filePath) => emit(SharedRecordDownloadSuccess(filePath)),
    );
  }
}
