import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/settings/data/repo/wallet_repo.dart';

class WalletRepoImpl implements WalletRepo {
  WalletRepoImpl(this._apiService);

  final ApiService _apiService;

  @override
  Future<Either<ApiError, double>> getWalletBalance() async {
    try {
      final dynamic response = await _apiService.get('/doctors/wallet');

      if (response is ServerFailure) {
        return Left(response);
      }

      final balanceValue = response['walletBalance'];
      final balance = balanceValue is num
          ? balanceValue.toDouble()
          : double.tryParse(balanceValue?.toString() ?? '') ?? 0;

      return Right(balance);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> requestWithdrawal({
    required double amount,
    required String bankName,
    required String accountNumber,
    required String accountHolderName,
  }) async {
    try {
      final dynamic response = await _apiService.post(
        '/doctors/wallet/withdraw',
        {
          'amount': amount,
          'bankDetails': {
            'bankName': bankName,
            'accountNumber': accountNumber,
            'accountHolderName': accountHolderName,
          },
        },
      );

      if (response is ServerFailure) {
        return Left(response);
      }

      return Right(
        response['message'] ?? 'Withdrawal request submitted successfully',
      );
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
