import 'package:equatable/equatable.dart';

enum AddPatientStatus { initial, loading, success, failure }
enum AddPatientAction { sendRequest, cancelRequest }

class AddPatientState extends Equatable {
  const AddPatientState({
    this.status = AddPatientStatus.initial,
    this.lastAction,
    this.errorMessage,
  });

  final AddPatientStatus status;
  final AddPatientAction? lastAction;
  final String? errorMessage;

  AddPatientState copyWith({
    AddPatientStatus? status,
    AddPatientAction? lastAction,
    bool clearAction = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AddPatientState(
      status: status ?? this.status,
      lastAction: clearAction ? null : (lastAction ?? this.lastAction),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, lastAction, errorMessage];
}
