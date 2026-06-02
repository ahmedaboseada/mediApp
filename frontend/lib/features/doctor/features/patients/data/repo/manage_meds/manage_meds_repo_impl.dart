import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:medi/core/core.dart';

import 'manage_meds_repo.dart';

class ManageMedsRepoImpl implements ManageMedsRepo {
  final ApiService apiService;
  final NotificationDispatchService _notificationDispatchService =
      NotificationDispatchService();

  ManageMedsRepoImpl(this.apiService);

  @override
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
  }) async {
    try {
      final Map<String, dynamic> data = {
        'patientId': patientId,
        'name': name,
        'type': type,
        'dosage': dosage,
        'frequency': frequency,
      };

      final normalizedFrequency = frequency.trim().toLowerCase();
      if (normalizedFrequency == 'weekly') {
        data['daily'] = <String>[];
        data['specific'] = <Map<String, dynamic>>[];
        data['weekly'] = (weekly ?? const <Map<String, dynamic>>[])
            .map(_normalizeWeeklyEntry)
            .toList();
      } else if (normalizedFrequency == 'specific') {
        data['daily'] = <String>[];
        data['weekly'] = <Map<String, dynamic>>[];
        data['specific'] = (specific ?? const <Map<String, dynamic>>[])
            .map(_normalizeSpecificEntry)
            .toList();
      } else {
        data['daily'] = daily ?? <String>[];
        data['weekly'] = <Map<String, dynamic>>[];
        data['specific'] = <Map<String, dynamic>>[];
      }

      final dynamic response = await apiService.post('/medications', data);

      log('Add Patient Medication Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final message =
          (response is Map<String, dynamic> ? response['message'] : null) ??
          'Medication added successfully';

      await _sendMedicationNotification(
        recipientFcmToken: recipientFcmToken,
        patientId: patientId,
        medicationName: name,
        kind: _MedicationNotificationKind.added,
      );

      return Right(message.toString());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Map<String, dynamic> _normalizeWeeklyEntry(Map<String, dynamic> entry) {
    final rawTimes = entry['times'];
    final times = rawTimes is List
        ? rawTimes.whereType<String>().map(_normalizeTimeString).toList()
        : <String>[];

    return {
      'day': (entry['day'] ?? entry['date'] ?? '').toString().trim(),
      'times': times,
    };
  }

  Map<String, dynamic> _normalizeSpecificEntry(Map<String, dynamic> entry) {
    final rawTimes = entry['times'];
    final times = rawTimes is List
        ? rawTimes.whereType<String>().map(_normalizeTimeString).toList()
        : <String>[];

    return {
      'day': (entry['day'] ?? entry['date'] ?? '').toString().trim(),
      'times': times,
    };
  }

  String _normalizeTimeString(String value) {
    final trimmed = value.trim();
    final match = RegExp(
      r'^(\d{1,2}):(\d{2})\s*([AaPp][Mm])$',
    ).firstMatch(trimmed);

    if (match == null) {
      return trimmed;
    }

    var hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    final period = match.group(3)!.toUpperCase();

    if (period == 'PM' && hour != 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  @override
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
  }) async {
    try {
      final Map<String, dynamic> data = {'patientId': patientId};

      if (name != null && name.trim().isNotEmpty) {
        data['name'] = name;
      }
      if (type != null && type.trim().isNotEmpty) {
        data['type'] = type;
      }
      if (dosage != null && dosage.trim().isNotEmpty) {
        data['dosage'] = dosage;
      }
      if (frequency != null && frequency.trim().isNotEmpty) {
        data['frequency'] = frequency;
      }
      final normalizedFrequency = frequency?.trim().toLowerCase();
      if (normalizedFrequency == 'weekly') {
        data['daily'] = <String>[];
        data['specific'] = <Map<String, dynamic>>[];
        data['weekly'] = (weekly ?? const <Map<String, dynamic>>[])
            .map(_normalizeWeeklyEntry)
            .toList();
      } else if (normalizedFrequency == 'specific') {
        data['daily'] = <String>[];
        data['weekly'] = <Map<String, dynamic>>[];
        data['specific'] = (specific ?? const <Map<String, dynamic>>[])
            .map(_normalizeSpecificEntry)
            .toList();
      } else if (daily != null && daily.isNotEmpty) {
        data['daily'] = daily;
        data['weekly'] = <Map<String, dynamic>>[];
        data['specific'] = <Map<String, dynamic>>[];
      }
      if (instructions != null && instructions.trim().isNotEmpty) {
        data['instructions'] = instructions;
      }

      final dynamic response = await apiService.put(
        '/medications/$medicationId',
        data,
      );

      log('Update Patient Medication Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final message =
          (response is Map<String, dynamic> ? response['message'] : null) ??
          'Medication updated successfully';

      await _sendMedicationNotification(
        recipientFcmToken: recipientFcmToken,
        patientId: patientId,
        medicationName: name ?? medicationId,
        kind: _MedicationNotificationKind.updated,
      );

      return Right(message.toString());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> deleteMedication({
    required String medicationId,
    required String patientId,
    required String deletedMedicationName,
    String? recipientFcmToken,
  }) async {
    try {
      final dynamic response = await apiService.delete(
        '/medications/$medicationId',
        {'patientId': patientId},
      );

      log('Delete Patient Medication Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final message =
          (response is Map<String, dynamic> ? response['message'] : null) ??
          'Medication deleted successfully';

      await _sendMedicationNotification(
        recipientFcmToken: recipientFcmToken,
        patientId: patientId,
        medicationName: deletedMedicationName,
        kind: _MedicationNotificationKind.deleted,
      );

      return Right(message.toString());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<void> _sendMedicationNotification({
    required String? recipientFcmToken,
    required String patientId,
    required String medicationName,
    required _MedicationNotificationKind kind,
  }) async {
    final token = recipientFcmToken?.trim() ?? '';
    if (token.isEmpty) {
      log('Medication notification skipped: missing recipientFcmToken for $patientId');
      return;
    }

    final result = kind == _MedicationNotificationKind.added
        ? await _notificationDispatchService.sendMedicationAdded(
            recipientFcmToken: token,
            medicationName: medicationName,
            recipientUserId: patientId,
          )
        : kind == _MedicationNotificationKind.updated
            ? await _notificationDispatchService.sendMedicationUpdated(
                recipientFcmToken: token,
                medicationName: medicationName,
                recipientUserId: patientId,
              )
            : await _notificationDispatchService.sendMedicationDeleted(
                recipientFcmToken: token,
                medicationName: medicationName,
                recipientUserId: patientId,
              );

    result.fold(
      (error) => log('Medication notification failed: ${error.message}'),
      (message) => log('Medication notification sent: $message'),
    );
  }
}

enum _MedicationNotificationKind { added, updated, deleted }
