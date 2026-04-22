import 'package:equatable/equatable.dart';

enum AddPatientStatus { initial, loading, success, failure }

class AddPatientState extends Equatable {
  const AddPatientState({
    this.status = AddPatientStatus.initial,
    this.errorMessage,
  });

  final AddPatientStatus status;
  final String? errorMessage;

  AddPatientState copyWith({
    AddPatientStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AddPatientState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
