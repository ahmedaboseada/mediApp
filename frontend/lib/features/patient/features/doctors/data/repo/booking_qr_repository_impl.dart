import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/doctors/data/repo/booking_qr_repository.dart';

class BookingQrRepositoryImpl implements BookingQrRepository {
  BookingQrRepositoryImpl(this._apiService);

  final ApiService _apiService;

  @override
  Future<Either<ApiError, String>> generateSessionToken(
    String appointmentId,
  ) async {
    try {
      final dynamic response = await _apiService.post(
        '/bookings/$appointmentId/generate-qr',
        const {},
      );

      log('Generate Booking QR Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final token = response is Map
          ? (response['sessionToken'] ?? '').toString()
          : '';

      if (token.isEmpty) {
        return Left(ServerFailure('Session token not found in response'));
      }

      return Right(token);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
