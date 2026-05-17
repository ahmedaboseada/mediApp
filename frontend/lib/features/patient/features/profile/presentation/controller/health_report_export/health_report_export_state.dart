
abstract class HealthReportExportState {
  const HealthReportExportState();
}

class HealthReportExportInitial extends HealthReportExportState {
  const HealthReportExportInitial();
}

class HealthReportExportLoading extends HealthReportExportState {}

class HealthReportExportSuccess extends HealthReportExportState {
  final String filePath;
  HealthReportExportSuccess(this.filePath);
}

class HealthReportExportFailure extends HealthReportExportState {
  final String error;
  HealthReportExportFailure(this.error);
}
