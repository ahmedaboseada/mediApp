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
