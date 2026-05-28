import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/home/data/models/emergency_contact_model.dart';
import 'package:medi/features/patient/features/home/data/repo/sos_repo.dart';

class SosRepoImpl implements SosRepo {
  final ApiService apiService;

  SosRepoImpl(this.apiService);

  @override
  Future<Either<ApiError, String>> setEmergencyContact({
    required String name,
    required String phone,
    required String contactMethod,
  }) async {
    try {
      final token = await HiveService.getAccessToken();
      log(
        'Setting Emergency Contact - Token: ${token != null ? "EXISTS" : "NULL"}',
      );

      if (token == null || token.isEmpty) {
        return Left(
          ServerFailure('Access token is missing. Please login again.'),
        );
      }

      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      final data = {
        'name': name,
        'phone': phone,
        'contactMethod': contactMethod,
      };

      final dynamic response = await apiService.patch(
        '/patients/emergency-contact',
        data,
        headers: headers,
      );

      log('Set Emergency Contact Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final message =
          response['message'] ?? 'Emergency contact updated successfully';

      // Persist emergency contact locally for quick access
      try {
        final contact = EmergencyContactModel(
          name: name,
          phone: phone,
          contactMethod: contactMethod,
        );
        await HiveService.saveEmergencyContact(contact.toJson());
        log('[SosRepoImpl] Emergency contact saved locally');
      } catch (e) {
        log('[SosRepoImpl] Failed to save emergency contact locally: $e');
      }

      return Right(message.toString());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> triggerSos({
    required double lat,
    required double lng,
  }) async {
    try {
      final token = await HiveService.getAccessToken();
      log('Triggering SOS - Token: ${token != null ? "EXISTS" : "NULL"}');

      if (token == null || token.isEmpty) {
        return Left(
          ServerFailure('Access token is missing. Please login again.'),
        );
      }

      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      final dynamic response = await apiService.post('/patients/sos', {
        'lat': lat,
        'lng': lng,
      }, headers: headers);

      log('Trigger SOS Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final message = response['message'] ?? 'SOS triggered successfully';
      return Right(message.toString());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
