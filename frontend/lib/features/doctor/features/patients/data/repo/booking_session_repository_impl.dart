import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:medi/core/core.dart';
import '../models/booking_session_model.dart';
import 'booking_session_repository.dart';

class BookingSessionRepositoryImpl implements BookingSessionRepository {
  BookingSessionRepositoryImpl(this._apiService);

  final ApiService _apiService;

  @override
  Future<Either<ApiError, BookingSessionModel>> startSession(
    String sessionToken,
  ) async {
    try {
      final dynamic response = await _apiService.post(
        '/bookings/start-session',
        {'sessionToken': sessionToken},
      );

      log('Start session response: ${response.toString()}');

      if (response is ServerFailure) return Left(response);

      if (response is Map) {
        final model = BookingSessionModel.fromJson(response);
        if (model.bookingId.isEmpty) {
          return Left(ServerFailure('bookingId missing in response'));
        }
        return Right(model);
      }

      return Left(ServerFailure('Invalid response format from server'));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, void>> endSession(String bookingId) async {
    try {
      final dynamic response = await _apiService.post(
        '/bookings/$bookingId/end-session',
        const {},
      );

      log('End session response: ${response.toString()}');

      if (response is ServerFailure) return Left(response);

      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
