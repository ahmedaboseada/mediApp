import 'package:meta/meta.dart';

@immutable
sealed class HealthPassportExportState {}

final class HealthPassportExportInitial extends HealthPassportExportState {}

final class HealthPassportExportLoading extends HealthPassportExportState {}

final class HealthPassportExportSuccess extends HealthPassportExportState {
  final String filePath;
  HealthPassportExportSuccess(this.filePath);
}

final class HealthPassportExportFailure extends HealthPassportExportState {
  final String error;
  HealthPassportExportFailure(this.error);
}

// QR Token States
@immutable
sealed class QRTokenState {}

final class QRTokenInitial extends QRTokenState {}

final class QRTokenLoading extends QRTokenState {}

final class QRTokenSuccess extends QRTokenState {
  final String qrToken;
  QRTokenSuccess(this.qrToken);
}

final class QRTokenFailure extends QRTokenState {
  final String error;
  QRTokenFailure(this.error);
}

// Shared Record Download States
@immutable
sealed class SharedRecordDownloadState {}

final class SharedRecordDownloadInitial extends SharedRecordDownloadState {}

final class SharedRecordDownloadLoading extends SharedRecordDownloadState {}

final class SharedRecordDownloadSuccess extends SharedRecordDownloadState {
  final String filePath;
  SharedRecordDownloadSuccess(this.filePath);
}

final class SharedRecordDownloadFailure extends SharedRecordDownloadState {
  final String error;
  SharedRecordDownloadFailure(this.error);
}
