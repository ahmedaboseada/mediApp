import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/complete_profile/data/repo/doctor_complete_profile_repo.dart';

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
    String? profilePicture,
  }) async {
    try {
      final token = HiveService.getAccessToken();
      log('Doctor Complete Step1 - Token: ${token != null ? "EXISTS" : "NULL"}');
      if (token == null || token.isEmpty) {
        return Left(ServerFailure('Access token is missing. Please login again.'));
      }
      if (token.length > 50) {
        log('Doctor Complete Step1 - Token Preview: ${token.substring(0, 50)}...');
      }
      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };
      final data = {
        'specialization': specialization,
        'clinicName': clinicName,
        'medicalLicenseId': medicalLicenseId,
        'phone': phone,
        'gender': gender,
        if (profilePicture != null && profilePicture.isNotEmpty)
          'profilePicture': profilePicture,
      };

      final dynamic response = await apiService.patch(
        '/doctors/complete/step1',
        data,
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
      final token = HiveService.getAccessToken();
      log('Doctor Complete Location - Token: ${token != null ? "EXISTS" : "NULL"}');
      if (token == null || token.isEmpty) {
        return Left(ServerFailure('Access token is missing. Please login again.'));
      }

      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      final data = {
        'clinicAddress': clinicAddress,
        'clinicLocation': {
          'lat': lat,
          'lng': lng,
          'label': label,
        },
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
      final token = HiveService.getAccessToken();
      log('Doctor Complete Schedule - Token: ${token != null ? "EXISTS" : "NULL"}');
      if (token == null || token.isEmpty) {
        return Left(ServerFailure('Access token is missing. Please login again.'));
      }

      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      final data = {
        'workingDays': workingDays,
        'workingHours': [
          {
            'startHour': startHour,
            'endHour': endHour,
          },
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
      final token = HiveService.getAccessToken();
      log(
        'Doctor Complete Appointments - Token: ${token != null ? "EXISTS" : "NULL"}',
      );
      if (token == null || token.isEmpty) {
        return Left(ServerFailure('Access token is missing. Please login again.'));
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

      final message = response['message'] ?? 'Appointments completed successfully';
      return Right(message.toString());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> completeLicense({
    required String filePath,
  }) async {
    try {
      final token = HiveService.getAccessToken();
      log('Doctor Complete License - Token: ${token != null ? "EXISTS" : "NULL"}');
      if (token == null || token.isEmpty) {
        return Left(ServerFailure('Access token is missing. Please login again.'));
      }

      final file = File(filePath);
      if (!await file.exists()) {
        return Left(ServerFailure('License file not found'));
      }

      final fileName = filePath.split('/').last.split('\\').last;
      
      // final formData = FormData.fromMap({
      //   'licenseImage': await MultipartFile.fromFile(
      //     filePath,
      //     filename: 'license.png',
      //   ),
      // });
      // final data = {
      //   'licenseImage': await MultipartFile.fromFile(
      //     filePath,
      //     filename: fileName,
      //   ),
      // };
       final formData ={
       
        if (filePath != null && filePath.isNotEmpty)
          'licenseImage': await MultipartFile.fromFile(
            filePath,
            filename: 'profile.jpg',
          ),
      };

      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.patch(
        'https://medi-app-dusky.vercel.app/doctors/complete/license',
        data: formData,
        
      );

      log('Doctor Complete License Response: ${response.data.toString()}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        return Left(ServerFailure('Failed to upload license'));
      }

      final message = response.data['message'] ?? 'License uploaded successfully';
      return Right(message.toString());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
