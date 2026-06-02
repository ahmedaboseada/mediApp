import 'package:equatable/equatable.dart';
import 'package:medi/features/doctor/features/patients/data/models/incoming_patient_request_model.dart';

enum IncomingPatientRequestsStatus { initial, loading, success, empty, failure }

class IncomingPatientRequestsState extends Equatable {
  const IncomingPatientRequestsState({
    this.status = IncomingPatientRequestsStatus.initial,
    this.requests = const [],
    this.errorMessage,
    this.processingRequestId,
  });

  final IncomingPatientRequestsStatus status;
  final List<IncomingPatientRequestModel> requests;
  final String? errorMessage;
  final String? processingRequestId;

  IncomingPatientRequestsState copyWith({
    IncomingPatientRequestsStatus? status,
    List<IncomingPatientRequestModel>? requests,
    String? errorMessage,
    String? processingRequestId,
    bool clearError = false,
    bool clearProcessing = false,
  }) {
    return IncomingPatientRequestsState(
      status: status ?? this.status,
      requests: requests ?? this.requests,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      processingRequestId: clearProcessing
          ? null
          : (processingRequestId ?? this.processingRequestId),
    );
  }

  @override
  List<Object?> get props => [
    status,
    requests,
    errorMessage,
    processingRequestId,
  ];
}
