import 'package:dartz/dartz.dart';
import 'package:medi/core/core.dart';
import '../models/booking_session_model.dart';

abstract class BookingSessionRepository {
  Future<Either<ApiError, BookingSessionModel>> startSession(
    String sessionToken,
  );

  Future<Either<ApiError, void>> endSession(String bookingId);
}
