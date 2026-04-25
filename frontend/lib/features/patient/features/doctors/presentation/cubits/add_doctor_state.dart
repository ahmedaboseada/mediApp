import 'package:equatable/equatable.dart';

enum AddDoctorStatus { initial, loading, success, failure }

class AddDoctorState extends Equatable {
  const AddDoctorState({
    this.status = AddDoctorStatus.initial,
    this.errorMessage,
  });

  final AddDoctorStatus status;
  final String? errorMessage;

  AddDoctorState copyWith({
    AddDoctorStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AddDoctorState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
