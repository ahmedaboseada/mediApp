part of 'wallet_cubit.dart';

enum WalletStatus { initial, loading, success, submitting, failure }

class WalletState extends Equatable {
  const WalletState({
    this.status = WalletStatus.initial,
    this.balance = 0,
    this.message,
    this.errorMessage,
  });

  final WalletStatus status;
  final double balance;
  final String? message;
  final String? errorMessage;

  WalletState copyWith({
    WalletStatus? status,
    double? balance,
    String? message,
    String? errorMessage,
    bool clearError = false,
    bool clearMessage = false,
  }) {
    return WalletState(
      status: status ?? this.status,
      balance: balance ?? this.balance,
      message: clearMessage ? null : (message ?? this.message),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, balance, message, errorMessage];
}
