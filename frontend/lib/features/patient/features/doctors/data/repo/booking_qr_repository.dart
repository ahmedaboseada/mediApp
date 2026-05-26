import 'package:dartz/dartz.dart';
import 'package:medi/core/core.dart';

abstract class BookingQrRepository {
  Future<Either<ApiError, String>> generateSessionToken(String appointmentId);
}
