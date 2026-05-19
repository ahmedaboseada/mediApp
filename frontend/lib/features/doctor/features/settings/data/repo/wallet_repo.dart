import 'package:dartz/dartz.dart';
import 'package:medi/core/core.dart';

abstract class WalletRepo {
  Future<Either<ApiError, double>> getWalletBalance();

  Future<Either<ApiError, String>> requestWithdrawal({
    required double amount,
    required String bankName,
    required String accountNumber,
    required String accountHolderName,
  });
}
