import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/data/sync/sync_service.dart';
import 'package:medi/features/doctor/features/complete_profile/data/repo/doctor_complete_profile_repo.dart';
import 'package:medi/features/shared/auth/data/models/doctor_model.dart';
import 'package:medi/features/shared/auth/data/models/working_hours_model.dart';

class DoctorCompleteProfileRepoImpl implements DoctorCompleteProfileRepo {
  DoctorCompleteProfileRepoImpl(this.apiService);

  final ApiService apiService;

  @override
  Future<Either<ApiError, String>> completeStep1({
    required String specialization,
    required String clinicName,
    required String medicalLicenseId,
    required String phone,
    required String gender,
    File? profilePicture,
  }) async {
    try {
      final token = await HiveService.getAccessToken();
      log(
        'Doctor Complete Step1 - Token: ${token != null ? "EXISTS" : "NULL"}',
      );
      if (token == null || token.isEmpty) {
        return Left(
          ServerFailure('Access token is missing. Please login again.'),
        );
      }
      if (token.length > 50) {
        log(
          'Doctor Complete Step1 - Token Preview: ${token.substring(0, 50)}...',
        );
      }
      final headers = {
        "Content-Type": "multipart/form-data",
        "Authorization": "Bearer $token",
      };
      final data = <String, dynamic>{
        'specialization': specialization,
        'clinicName': clinicName,
        'medicalLicenseId': medicalLicenseId,
        'phone': phone,
        'gender': gender,
      };

      if (profilePicture != null) {
        final fileName = profilePicture.path.split(RegExp(r'[\\/]')).last;
        data['avatar'] = await MultipartFile.fromFile(
          profilePicture.path,
          filename: fileName,
        );
      }

      final formData = FormData.fromMap(data);

      final dynamic response = await apiService.patch(
        '/doctors/complete/step1',
        formData,
        headers: headers,
      );

      log('Doctor Complete Step1 Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final message = response['message'] ?? 'Step 1 completed successfully';
      return Right(message);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> completeLocation({
    required String clinicAddress,
    required double lat,
    required double lng,
    required String label,
  }) async {
    try {
      final token = await HiveService.getAccessToken();
      log(
        'Doctor Complete Location - Token: ${token != null ? "EXISTS" : "NULL"}',
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
        'clinicAddress': clinicAddress,
        'clinicLocation': {'lat': lat, 'lng': lng, 'label': label},
      };

      final dynamic response = await apiService.patch(
        '/doctors/complete/location',
        data,
        headers: headers,
      );
      log('Doctor Complete Location Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final message = response['message'] ?? 'Location completed successfully';
      return Right(message.toString());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> completeSchedule({
    required List<String> workingDays,
    required String startHour,
    required String endHour,
    required int consultationDuration,
  }) async {
    try {
      final token = await HiveService.getAccessToken();
      log(
        'Doctor Complete Schedule - Token: ${token != null ? "EXISTS" : "NULL"}',
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
        'workingDays': _formatWorkingDays(workingDays),
        'workingHours': [
          {'startHour': startHour, 'endHour': endHour},
        ],
        'consultationDuration': consultationDuration,
      };

      final dynamic response = await apiService.patch(
        '/doctors/complete/schedule',
        data,
        headers: headers,
      );
      log('Doctor Complete Schedule Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final message = response['message'] ?? 'Schedule completed successfully';
      return Right(message.toString());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> completeAppointments({
    required List<String> appointmentTypes,
    required int maxDailyPatients,
  }) async {
    try {
      final token = await HiveService.getAccessToken();
      log(
        'Doctor Complete Appointments - Token: ${token != null ? "EXISTS" : "NULL"}',
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
        'appointmentTypes': appointmentTypes,
        'maxDailyPatients': maxDailyPatients,
      };

      final dynamic response = await apiService.patch(
        '/doctors/complete/appointments',
        data,
        headers: headers,
      );
      log('Doctor Complete Appointments Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final message =
          response['message'] ?? 'Appointments completed successfully';
      return Right(message.toString());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> updateSchedule({
    required List<String> workingDays,
    required String startHour,
    required String endHour,
    required int consultationDuration,
    required List<String> appointmentTypes,
    required int maxDailyPatients,
  }) async {
    final formattedWorkingDays = _formatWorkingDays(workingDays);
    final data = {
      'workingDays': formattedWorkingDays,
      'workingHours': [
        {'startHour': startHour, 'endHour': endHour},
      ],
      'consultationDuration': consultationDuration,
      'appointmentTypes': appointmentTypes,
      'maxDailyPatients': maxDailyPatients,
    };

    try {
      final token = await HiveService.getAccessToken();
      if (token == null || token.isEmpty) {
        return Left(
          ServerFailure('Access token is missing. Please login again.'),
        );
      }

      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      final dynamic response = await apiService.patch(
        '/doctors/schedule',
        data,
        headers: headers,
      );
      log('Doctor Update Schedule Response: ${response.toString()}');

      if (response is ServerFailure) {
        if (_isOfflineFailure(response)) {
          await _saveScheduleLocally(
            workingDays: formattedWorkingDays,
            startHour: startHour,
            endHour: endHour,
            consultationDuration: consultationDuration,
            appointmentTypes: appointmentTypes,
            maxDailyPatients: maxDailyPatients,
          );

          final doctor = await HiveService.getDoctorData();
          await SyncService.addToQueue(
            type: 'update',
            entity: 'doctorSchedule',
            data: {
              ...data,
              if (doctor != null) 'id': doctor.doctorId,
            },
          );

          return const Right('Schedule saved offline. Will sync when online.');
        }
        return Left(response);
      }

      await _saveScheduleLocally(
        workingDays: formattedWorkingDays,
        startHour: startHour,
        endHour: endHour,
        consultationDuration: consultationDuration,
        appointmentTypes: appointmentTypes,
        maxDailyPatients: maxDailyPatients,
      );

      final message = response['message'] ?? 'Schedule updated successfully';
      return Right(message.toString());
    } on DioException catch (e) {
      if (_isOfflineDioError(e)) {
        await _saveScheduleLocally(
          workingDays: formattedWorkingDays,
          startHour: startHour,
          endHour: endHour,
          consultationDuration: consultationDuration,
          appointmentTypes: appointmentTypes,
          maxDailyPatients: maxDailyPatients,
        );

        final doctor = await HiveService.getDoctorData();
        await SyncService.addToQueue(
          type: 'update',
          entity: 'doctorSchedule',
          data: {
            ...data,
            if (doctor != null) 'id': doctor.doctorId,
          },
        );

        return const Right('Schedule saved offline. Will sync when online.');
      }
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  bool _isOfflineDioError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return true;
    }
    return (e.message ?? '').contains('SocketException');
  }

  bool _isOfflineFailure(ServerFailure failure) {
    final msg = failure.message.toLowerCase();
    return msg.contains('internet') ||
        msg.contains('connection') ||
        msg.contains('timeout') ||
        msg.contains('socket');
  }

  Future<void> _saveScheduleLocally({
    required List<String> workingDays,
    required String startHour,
    required String endHour,
    required int consultationDuration,
    required List<String> appointmentTypes,
    required int maxDailyPatients,
  }) async {
    final doctor = await HiveService.getDoctorData();
    if (doctor == null) return;

    final updatedDoctor = DoctorModel(
      doctorId: doctor.doctorId,
      userId: doctor.userId,
      workingDays: workingDays,
      appointmentTypes: appointmentTypes,
      reviews: doctor.reviews,
      reviewsCount: doctor.reviewsCount,
      workingHours: [
        WorkingHoursModel(startHour: startHour, endHour: endHour),
      ],
      connectedPatients: doctor.connectedPatients,
      createdAt: doctor.createdAt,
      updatedAt: DateTime.now().toIso8601String(),
      clinicName: doctor.clinicName,
      medicalLicenseId: doctor.medicalLicenseId,
      specialization: doctor.specialization,
      clinicAddress: doctor.clinicAddress,
      clinicLocation: doctor.clinicLocation,
      consultationDuration: consultationDuration,
      maxDailyPatients: maxDailyPatients,
    );

    await HiveService.saveDoctorData(updatedDoctor);
  }

  List<String> _formatWorkingDays(List<String> days) {
    final Map<String, String> dayMap = {
      'Mon': 'monday',
      'Tue': 'tuesday',
      'Wed': 'wednesday',
      'Thu': 'thursday',
      'Fri': 'friday',
      'Sat': 'saturday',
      'Sun': 'sunday',
    };

    return days.map((day) => dayMap[day] ?? day.toLowerCase()).toList();
  }

  @override
  Future<Either<ApiError, String>> completeLicense({
    required String filePath,
  }) async {
    try {
      final token = await HiveService.getAccessToken();
      log(
        'Doctor Complete License - Token: ${token != null ? "EXISTS" : "NULL"}',
      );

      if (token == null || token.isEmpty) {
        return Left(
          ServerFailure('Access token is missing. Please login again.'),
        );
      }

      final file = File(filePath);
      if (!await file.exists()) {
        return Left(ServerFailure('License file not found'));
      }

      final fileName = file.path.split(RegExp(r'[\\/]')).last;
      final formData = FormData.fromMap({
        'licenseImage': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      final headers = {'Authorization': 'Bearer $token'};

      final dynamic response = await apiService.patch(
        '/doctors/complete/license',
        formData,
        headers: headers,
      );

      log('Doctor Complete License Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final message = response['message'] ?? 'License uploaded successfully';
      return Right(message.toString());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
