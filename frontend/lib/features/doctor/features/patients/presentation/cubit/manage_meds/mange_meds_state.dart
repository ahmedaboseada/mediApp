part of 'mange_meds_cubit.dart';

enum ManageMedsStatus { initial, loading, success, failure }

class ManageMedsState extends Equatable {
  const ManageMedsState({
    this.status = ManageMedsStatus.initial,
    this.message,
    this.errorMessage,
  });

  final ManageMedsStatus status;
  final String? message;
  final String? errorMessage;

  ManageMedsState copyWith({
    ManageMedsStatus? status,
    String? message,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ManageMedsState(
      status: status ?? this.status,
      message: message ?? this.message,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, message, errorMessage];
}
