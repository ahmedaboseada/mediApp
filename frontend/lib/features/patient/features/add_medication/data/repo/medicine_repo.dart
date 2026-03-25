import 'package:dartz/dartz.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';

abstract class MedicineRepo {
  Future<Either<ApiError, String>> addMedicine({
    required String activeIngredient,
    required String type,
    required String frequency,
    required List<String> daily,
    required String dosage,
    required int stock,
  });

  Future<Either<ApiError, String>> addMedicineFromMedication(
    Medication medication,
  );

  Future<Either<ApiError, List<Medication>>> getActiveMedications();

  Future<Either<ApiError, String>> markAsTaken({
    required String medicationId,
    required String date,
    required String time,
    required bool taken,
  });

  Future<Either<ApiError, String>> addDailyLog({
    required String medicationId,
    required String text,
    required String level,
  });
}
