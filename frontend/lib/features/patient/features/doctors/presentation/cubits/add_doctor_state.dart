import 'package:equatable/equatable.dart';

enum AddDoctorStatus { initial, loading, success, failure }
enum AddDoctorAction { sendRequest, cancelRequest }

class AddDoctorState extends Equatable {
  const AddDoctorState({
    this.status = AddDoctorStatus.initial,
    this.lastAction,
    this.errorMessage,
  });

  final AddDoctorStatus status;
  final AddDoctorAction? lastAction;
  final String? errorMessage;

  AddDoctorState copyWith({
    AddDoctorStatus? status,
    AddDoctorAction? lastAction,
    bool clearAction = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AddDoctorState(
      status: status ?? this.status,
      lastAction: clearAction ? null : (lastAction ?? this.lastAction),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, lastAction, errorMessage];
}
