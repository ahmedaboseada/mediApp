//

import 'package:dartz/dartz.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/doctors/data/models/doctor_summary.dart';

abstract class DoctorsRepository {
  Future<Either<ApiError, List<DoctorModel>>> getGlobalDoctors();
}
