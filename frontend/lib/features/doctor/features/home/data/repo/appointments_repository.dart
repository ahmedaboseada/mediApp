import 'package:dartz/dartz.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/home/data/models/doctor_appointment_model.dart';

abstract class AppointmentsRepository {
  Future<Either<ApiError, List<DoctorAppointmentModel>>> getAppointmentsForDate(
    DateTime date,
  );

  Future<List<DoctorAppointmentModel>> getCachedAppointmentsForDate(DateTime date);
}
