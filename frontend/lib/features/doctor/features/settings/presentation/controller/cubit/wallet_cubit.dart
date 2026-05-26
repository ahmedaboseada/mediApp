import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/doctor/features/settings/data/repo/wallet_repo.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit(this._repository) : super(const WalletState());

  final WalletRepo _repository;

  Future<void> loadWallet() async {
    emit(
      state.copyWith(
        status: WalletStatus.loading,
        clearError: true,
        clearMessage: true,
      ),
    );

    final result = await _repository.getWalletBalance();
    if (isClosed) return;

    result.fold(
      (error) {
        if (isClosed) return;
        emit(
          state.copyWith(
            status: WalletStatus.failure,
            errorMessage: error.message,
          ),
        );
      },
      (balance) {
        if (isClosed) return;
        emit(
          state.copyWith(
            status: WalletStatus.success,
            balance: balance,
            clearError: true,
            clearMessage: true,
          ),
        );
      },
    );
  }

  Future<void> requestWithdrawal({
    required String bankName,
    required String accountNumber,
    required String accountHolderName,
    required double amount,
  }) async {
    emit(state.copyWith(status: WalletStatus.submitting, clearError: true));

    final result = await _repository.requestWithdrawal(
      amount: amount,
      bankName: bankName,
      accountNumber: accountNumber,
      accountHolderName: accountHolderName,
    );

    if (isClosed) return;

    String? successMessage;
    result.fold(
      (error) {
        if (isClosed) return;
        emit(
          state.copyWith(
            status: WalletStatus.failure,
            errorMessage: error.message,
          ),
        );
      },
      (message) {
        successMessage = message;
      },
    );

    if (successMessage == null || isClosed) {
      return;
    }

    await loadWallet();
    if (isClosed) return;
    emit(
      state.copyWith(
        status: WalletStatus.success,
        message: successMessage,
        clearError: true,
      ),
    );
  }

  void clearMessage() {
    emit(state.copyWith(message: null));
  }
}
