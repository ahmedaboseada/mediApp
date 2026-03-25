import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';
import 'package:medi/features/patient/features/add_medication/data/repo/medicine_repo.dart';

class MedicineRepoImpl implements MedicineRepo {
  final ApiService apiService;

  MedicineRepoImpl(this.apiService);

  @override
  Future<Either<ApiError, String>> addMedicine({
    required String activeIngredient,
    required String type,
    required String frequency,
    required List<String> daily,
    required String dosage,
    required int stock,
  }) async {
    try {
      final data = {
        'activeIngredient': activeIngredient,
        'type': type,
        'frequency': frequency,
        'daily': daily,
        'dosage': dosage,
        'stock': stock,
      };

      final dynamic response = await apiService.post('/medications', data);

      log('Add Medicine Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final message =
          (response is Map<String, dynamic> ? response['message'] : null) ??
          'Medication added successfully';
      return Right(message.toString());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> addMedicineFromMedication(
    Medication medication,
  ) {
    return addMedicine(
      activeIngredient: medication.name,
      type: medication.type,
      frequency: _toApiFrequency(medication.frequency),
      daily: medication.reminders,
      dosage: medication.dosage,
      stock: medication.stock,
    );
  }

  @override
  Future<Either<ApiError, List<Medication>>> getActiveMedications() async {
    try {
      dynamic response = await apiService.get('/medications?filter=active');

      log('Get Active Medications Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      //final medications = _extractMedications(response);
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> markAsTaken({
    required String medicationId,
    required String date,
    required String time,
    required bool taken,
  }) async {
    try {
      final data = {'date': date, 'time': time, 'taken': taken};

      final dynamic response = await apiService.patch(
        '/medications/$medicationId/taken',
        data,
      );

      log('Mark As Taken Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final message =
          (response is Map<String, dynamic> ? response['message'] : null) ??
          'Medication marked as taken successfully';
      return Right(message.toString());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> addDailyLog({
    required String medicationId,
    required String text,
    required String level,
  }) async {
    try {
      final data = {'text': text, 'level': level};

      final dynamic response = await apiService.post(
        '/medications/$medicationId/log',
        data,
      );

      log('Add Daily Log Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final message =
          (response is Map<String, dynamic> ? response['message'] : null) ??
          'Daily log added successfully';
      return Right(message.toString());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  String _toApiFrequency(String value) {
    final normalized = value.trim().toLowerCase();
    switch (normalized) {
      case 'every day':
        return 'daily';
      case 'every week':
        return 'weekly';
      case 'every month':
        return 'monthly';
      default:
        return normalized;
    }
  }
}
