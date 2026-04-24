//

import 'package:dartz/dartz.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/doctors/data/models/booking_model.dart';
import 'package:medi/features/patient/features/doctors/data/models/doctor_summary.dart';

abstract class DoctorsRepository {
  Future<Either<ApiError, List<DoctorModel>>> getGlobalDoctors();
  Future<Either<ApiError, List<String>>> getDoctorSlots(
    String doctorId,
    String date,
  );
  Future<Either<ApiError, dynamic>> createBooking(
    Map<String, dynamic> bookingData,
  );
  Future<Either<ApiError, List<BookingModel>>> getPatientBookings();
  Future<Either<ApiError, void>> cancelBooking(String bookingId, String reason);
}
