import 'package:dartz/dartz.dart';
import 'package:medi/core/core.dart';

abstract class ManageMedsRepo {
  Future<Either<ApiError, String>> addMedication({
    required String patientId,
    required String name,
    required String type,
    required String dosage,
    required String frequency,
    String? recipientFcmToken,
    List<String>? daily,
    List<Map<String, dynamic>>? weekly,
    List<Map<String, dynamic>>? specific,
  });

  Future<Either<ApiError, String>> updateMedication({
    required String medicationId,
    required String patientId,
    String? name,
    String? type,
    String? dosage,
    String? frequency,
    String? recipientFcmToken,
    List<String>? daily,
    List<Map<String, dynamic>>? weekly,
    List<Map<String, dynamic>>? specific,
    String? instructions,
  });

  Future<Either<ApiError, String>> deleteMedication({
    required String medicationId,
    required String patientId,
    required String deletedMedicationName,
    String? recipientFcmToken,
  });
}
