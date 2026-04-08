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
  }) async {
    try {
      final data = _buildMedicinePayload(
        name: name,
        type: type,
        frequency: frequency,
        daily: daily,
        specific: specific,
        weekly: weekly,
        dosage: dosage,
        stock: stock,
        criticalMode: criticalMode,
        notes: notes,
        isChronic: isChronic,
        status: status,
      );

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
  }) async {
    try {
      final data = _buildMedicinePayload(
        name: name,
        type: type,
        frequency: frequency,
        daily: daily,
        specific: specific,
        weekly: weekly,
        dosage: dosage,
        stock: stock,
        criticalMode: criticalMode,
        notes: notes,
        isChronic: isChronic,
        status: status,
      );

      final dynamic response = await apiService.put(
        '/medications/$medicationId',
        data,
      );

      log('Update Medicine Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final message =
          (response is Map<String, dynamic> ? response['message'] : null) ??
          'Medication updated successfully';
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
    final apiFrequency = _toApiFrequency(medication.frequency);
    final reminders = _normalizeTimes(medication.reminders);

    final weeklyPayload = apiFrequency == 'weekly' && reminders.isNotEmpty
        ? <Map<String, dynamic>>[
            {'day': _resolveWeeklyDay(medication.schedule), 'times': reminders},
          ]
        : null;

    return addMedicine(
      name: medication.name,
      type: medication.type,
      frequency: apiFrequency,
      daily: apiFrequency == 'daily' ? reminders : null,
      weekly: weeklyPayload,
      dosage: medication.dosage.trim().isEmpty ? null : medication.dosage,
      stock: medication.stock == 0 ? null : medication.stock,
      criticalMode: medication.isCriticalMode,
      isChronic: medication.isChronic,
    );
  }

  @override
  Future<Either<ApiError, String>> updateMedicineFromMedication({
    required String medicationId,
    required Medication medication,
  }) {
    final apiFrequency = _toApiFrequency(medication.frequency);
    final reminders = _normalizeTimes(medication.reminders);

    final weeklyPayload = apiFrequency == 'weekly' && reminders.isNotEmpty
        ? <Map<String, dynamic>>[
            {'day': _resolveWeeklyDay(medication.schedule), 'times': reminders},
          ]
        : null;

    return updateMedicine(
      medicationId: medicationId,
      name: medication.name,
      type: medication.type,
      frequency: apiFrequency,
      daily: apiFrequency == 'daily' ? reminders : null,
      weekly: weeklyPayload,
      dosage: medication.dosage.trim().isEmpty ? null : medication.dosage,
      stock: medication.stock == 0 ? null : medication.stock,
      criticalMode: medication.isCriticalMode,
      isChronic: medication.isChronic,
    );
  }

  @override
  Future<Either<ApiError, List<Medication>>> getAllMedications() async {
    try {
      dynamic response = await apiService.get('/medications');

      log('Get All Medications Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      return Right(_extractMedications(response));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, List<Medication>>> getActiveMedications() async {
    try {
      final dynamic response = await apiService.get(
        '/medications?filter=active',
      );

      log('Get Active Medications Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      return Right(_extractMedications(response));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> getMedicationSchedule() async {
    try {
      final dynamic response = await apiService.get('/medications/schedule');

      log('Get Medication Schedule Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

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
  Future<Either<ApiError, String>> deleteMedication({
    required String medicationId,
  }) async {
    try {
      final dynamic response = await apiService.delete(
        '/medications/$medicationId',
        const <String, dynamic>{},
      );

      log('Delete Medication Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final message =
          (response is Map<String, dynamic> ? response['message'] : null) ??
          'Medication deleted successfully';
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
      case 'daily':
      case 'once daily':
      case 'twice daily':
      case 'every day':
      case 'every 2 days':
      case 'every 3 days':
      case 'as needed':
        return 'daily';
      case 'weekly':
      case 'every week':
      case 'every 2 weeks':
        return 'weekly';
      case 'specific':
        return 'specific';
      default:
        // Backend currently validates frequency against: daily, weekly, specific.
        return 'daily';
    }
  }

  Map<String, dynamic> _buildMedicinePayload({
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
  }) {
    final data = <String, dynamic>{
      'name': name,
      'type': _toApiType(type),
      'frequency': frequency,
    };

    final normalizedFrequency = frequency.trim().toLowerCase();
    switch (normalizedFrequency) {
      case 'daily':
        if (daily != null && daily.isNotEmpty) {
          data['daily'] = _normalizeTimes(daily);
        }
        break;
      case 'specific':
        if (specific != null && specific.isNotEmpty) {
          data['specific'] = _normalizeSpecificSchedule(specific);
        }
        break;
      case 'weekly':
        if (weekly != null && weekly.isNotEmpty) {
          data['weekly'] = _normalizeWeeklySchedule(weekly);
        }
        break;
      default:
        if (daily != null && daily.isNotEmpty) {
          data['daily'] = _normalizeTimes(daily);
        }
        if (specific != null && specific.isNotEmpty) {
          data['specific'] = _normalizeSpecificSchedule(specific);
        }
        if (weekly != null && weekly.isNotEmpty) {
          data['weekly'] = _normalizeWeeklySchedule(weekly);
        }
    }

    if (dosage != null && dosage.trim().isNotEmpty) {
      data['dosage'] = dosage;
    }
    if (stock != null) {
      data['stock'] = stock;
    }
    if (criticalMode != null) {
      data['criticalMode'] = criticalMode;
    }
    if (notes != null && notes.trim().isNotEmpty) {
      data['notes'] = notes;
    }
    if (isChronic != null) {
      data['isChronic'] = isChronic;
    }
    if (status != null && status.trim().isNotEmpty) {
      data['status'] = status;
    }

    return data;
  }

  String _toApiType(String value) {
    final normalized = value.trim().toLowerCase();
    switch (normalized) {
      case 'tablet':
      case 'pill':
        return 'tablet';
      case 'capsule':
        return 'capsule';
      case 'syrup':
      case 'bottle':
        return 'syrup';
      case 'injection':
      case 'syringe':
        return 'injection';
      case 'drops':
      case 'drop':
        return 'drops';
      case 'spray':
      case 'inhaler':
        return 'spray';
      case 'cream':
      case 'ointment':
        return 'cream';
      case 'other':
        return 'other';
      default:
        return 'other';
    }
  }

  String _resolveWeeklyDay(String schedule) {
    const allowedDays = <String>{
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    };

    final normalized = schedule.trim().toLowerCase();
    return allowedDays.contains(normalized) ? normalized : 'monday';
  }

  List<String> _normalizeTimes(List<String> times) {
    return times.map(_normalizeApiTime).where((t) => t.isNotEmpty).toList();
  }

  List<Map<String, dynamic>> _normalizeWeeklySchedule(
    List<Map<String, dynamic>> weekly,
  ) {
    return weekly.map((item) {
      final rawTimes = item['times'];
      final parsedTimes = rawTimes is List
          ? rawTimes.whereType<String>().toList()
          : const <String>[];

      return {...item, 'times': _normalizeTimes(parsedTimes)};
    }).toList();
  }

  List<Map<String, dynamic>> _normalizeSpecificSchedule(
    List<Map<String, dynamic>> specific,
  ) {
    return specific.map((item) {
      final rawTimes = item['times'];
      final parsedTimes = rawTimes is List
          ? rawTimes.whereType<String>().toList()
          : const <String>[];

      return {...item, 'times': _normalizeTimes(parsedTimes)};
    }).toList();
  }

  String _normalizeApiTime(String raw) {
    final value = raw.trim();
    final apiFormat = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$');
    if (apiFormat.hasMatch(value)) {
      return value;
    }

    final twelveHour = RegExp(r'^(1[0-2]|0?[1-9]):([0-5]\d)\s*([AaPp][Mm])$');
    final match = twelveHour.firstMatch(value);
    if (match == null) {
      return value;
    }

    final hourRaw = int.parse(match.group(1)!);
    final minute = match.group(2)!;
    final period = match.group(3)!.toLowerCase();

    var hour = hourRaw;
    if (period == 'pm' && hour != 12) {
      hour += 12;
    } else if (period == 'am' && hour == 12) {
      hour = 0;
    }

    final hh = hour.toString().padLeft(2, '0');
    return '$hh:$minute';
  }

  List<Medication> _extractMedications(dynamic response) {
    final rawMedications = response is Map<String, dynamic>
        ? response['medicines'] ?? response['medications'] ?? response['data']
        : response;

    if (rawMedications is List) {
      return rawMedications
          .whereType<Map>()
          .map((item) => Medication.fromJson(item.cast<dynamic, dynamic>()))
          .toList();
    }

    return const <Medication>[];
  }
}
