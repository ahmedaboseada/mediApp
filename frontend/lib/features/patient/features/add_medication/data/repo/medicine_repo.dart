import 'package:dartz/dartz.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';

abstract class MedicineRepo {
  Future<Either<ApiError, String>> addMedicine({
    required String name,
    required String type,
    required String frequency,
    List<String>? daily,
    List<Map<String, dynamic>>? specific,
    List<Map<String, dynamic>>? weekly,
    String? dosage,
    int? stock,
    bool? criticalMode,
    String? notes,
    bool? isChronic,
    String? status,
  });

  Future<Either<ApiError, String>> addMedicineFromMedication(
    Medication medication,
  );

  Future<Either<ApiError, String>> updateMedicine({
    required String medicationId,
    required String name,
    required String type,
    required String frequency,
    List<String>? daily,
    List<Map<String, dynamic>>? specific,
    List<Map<String, dynamic>>? weekly,
    String? dosage,
    int? stock,
    bool? criticalMode,
    String? notes,
    bool? isChronic,
    String? status,
  });

  Future<Either<ApiError, String>> updateMedicineFromMedication({
    required String medicationId,
    required Medication medication,
  });

  Future<Either<ApiError, List<Medication>>> getAllMedications();

  Future<Either<ApiError, List<Medication>>> getActiveMedications();

  Future<Either<ApiError, dynamic>> getMedicationSchedule();

  Future<Either<ApiError, dynamic>> getMedicationScheduleForDate({
    required String date,
  });

  Future<Either<ApiError, String>> markAsTaken({
    required String medicationId,
    required String date,
    required String time,
    required bool taken,
  });

  Future<Either<ApiError, String>> deleteMedication({
    required String medicationId,
  });

  Future<Either<ApiError, String>> addDailyLog({
    required String medicationId,
    required String text,
    required String level,
  });

  Future<Either<ApiError, String>> getDoctorMedicationAccessToken();
}
