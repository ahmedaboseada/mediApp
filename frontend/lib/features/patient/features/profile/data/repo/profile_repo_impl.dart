import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/data/sync/sync_service.dart';
import 'package:medi/features/patient/features/profile/data/models/caregiver_request_model.dart';
import 'package:medi/features/patient/features/profile/data/models/doctor_request_model.dart';
import 'package:medi/features/patient/features/profile/data/models/managed_patient_summary.dart';
import 'package:medi/features/patient/features/profile/data/repo/profile_repo.dart';
import 'package:medi/features/shared/auth/data/models/user_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class ProfileRepoImpl implements ProfileRepo {
  final ApiService apiService;
  final NotificationDispatchService _notificationDispatchService =
      NotificationDispatchService();

  ProfileRepoImpl(this.apiService);

  @override
  Future<Either<ApiError, String>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final data = {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      };
      final token = await HiveService.getAccessToken();
      log('Access Token: $token');
      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      final response = await apiService.patch(
        '/users/changePassword',
        data,
        headers: headers,
      );

      log('Change Password Response: ${response.toString()}');

      // Check if response is an error
      if (response is ServerFailure) {
        return Left(response);
      }

      final message = response['message'] ?? 'Password changed successfully';

      log(
        'Message: $message--------------------------------------------------------------------------',
      );

      return Right(message);
    } on DioException catch (e) {
      final serverFailure = ServerFailure.fromDioError(e);
      return Left(serverFailure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> requestEmailChange({
    required String newEmail,
  }) async {
    try {
      final data = {'newEmail': newEmail};

      final token = await HiveService.getAccessToken();

      final response = await apiService.patch(
        '/users/email/change',
        data,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (response is ServerFailure) {
        return Left(response);
      }
      log('Request Email Change Response: ${response.toString()}');

      final message =
          response['message'] ?? 'Email change request sent successfully';

      return Right(message);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> cancelEmailChange() async {
    try {
      final token = await HiveService.getAccessToken();
      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      final response = await apiService.patch(
        '/users/email/cancel',
        {},
        headers: headers,
      );

      log('Cancel Email Change Response: ${response.toString()}');

      // Check if response is an error
      if (response is ServerFailure) {
        return Left(response);
      }

      final message =
          response['message'] ?? 'Email change cancelled successfully';

      return Right(message);
    } on DioException catch (e) {
      final serverFailure = ServerFailure.fromDioError(e);
      return Left(serverFailure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> confirmEmailChange({
    required String confirmEmailChangeToken,
  }) async {
    try {
      final response = await apiService.get(
        '/users/confirmEmailChange/$confirmEmailChangeToken',
      );

      log('Confirm Email Change Response: ${response.toString()}');

      // Check if response is an error
      if (response is ServerFailure) {
        return Left(response);
      }

      final message = response['message'] ?? 'Email changed successfully';

      return Right(message);
    } on DioException catch (e) {
      final serverFailure = ServerFailure.fromDioError(e);
      return Left(serverFailure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> toggleTwoFactorAuth(bool enabled) async {
    try {
      final token = await HiveService.getAccessToken();
      log('Access Token: $token');
      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      final response = await apiService.patch('/users/2fa', {
        'enabled': enabled,
      }, headers: headers);

      log('Toggle Two-Factor Auth Response: ${response.toString()}');

      // Check if response is an error
      if (response is ServerFailure) {
        if (_isOfflineFailure(response)) {
          await _saveTwoFactorLocally(enabled);
          final user = await HiveService.getUserData();
          await SyncService.addToQueue(
            type: 'update',
            entity: 'twoFactor',
            data: {
              'enabled': enabled,
              if (user != null) 'id': user.id,
            },
          );
          return const Right(
            'Two-Factor Authentication updated offline. Will sync when online.',
          );
        }
        return Left(response);
      }

      await _saveTwoFactorLocally(enabled);

      final message =
          response['message'] ??
          'Two-Factor Authentication toggled successfully';

      return Right(message);
    } on DioException catch (e) {
      if (_isOfflineDioError(e)) {
        await _saveTwoFactorLocally(enabled);
        final user = await HiveService.getUserData();
        await SyncService.addToQueue(
          type: 'update',
          entity: 'twoFactor',
          data: {
            'enabled': enabled,
            if (user != null) 'id': user.id,
          },
        );
        return const Right(
          'Two-Factor Authentication updated offline. Will sync when online.',
        );
      }
      final serverFailure = ServerFailure.fromDioError(e);
      return Left(serverFailure);
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

  Future<void> _saveTwoFactorLocally(bool enabled) async {
    await HiveService.setTwoFactorEnabled(enabled);

    final currentUser = await HiveService.getUserData();
    if (currentUser == null) return;

    final updatedUser = UserModel(
      id: currentUser.id,
      type: currentUser.type,
      firstName: currentUser.firstName,
      lastName: currentUser.lastName,
      email: currentUser.email,
      twoFA: enabled,
      profilePicture: currentUser.profilePicture,
      confirmed: currentUser.confirmed,
      gender: currentUser.gender,
      dob: currentUser.dob,
      age: currentUser.age,
      phone: currentUser.phone,
    );

    await HiveService.saveUserData(updatedUser);
  }

  @override
  Future<Either<ApiError, List<CaregiverRequestModel>>>
  listCaregiverRequests() async {
    try {
      final token = await HiveService.getAccessToken();
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await apiService.get(
        '/patients/caregiver/requests',
        headers: headers,
      );

      if (response is ServerFailure) {
        return Left(response);
      }
      log('List Caregiver Requests Response: ${response.toString()}');

      final requestsJson = (response['requests'] as List<dynamic>? ?? []);
      final requests = requestsJson
          .whereType<Map<String, dynamic>>()
          .map(CaregiverRequestModel.fromJson)
          .toList();

      return Right(requests);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> acceptCaregiverRequest({
    required String requestId,
    String? caregiverFcmToken,
    String? caregiverId,
    String? caregiverName,
  }) async {
    try {
      final token = await HiveService.getAccessToken();
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await apiService.patch(
        '/patients/caregiver/requests/$requestId/accept',
        {},
        headers: headers,
      );

      if (response is ServerFailure) {
        return Left(response);
      }

      if (caregiverFcmToken != null && caregiverFcmToken.trim().isNotEmpty) {
        final user = await HiveService.getUserData();
        await _notificationDispatchService.sendCaregiverRequestAccepted(
          recipientFcmToken: caregiverFcmToken,
          caregiverName: '${user?.firstName ?? ''} ${user?.lastName ?? ''}'.trim(),
          recipientUserId: caregiverId ?? '',
          senderName: '${user?.firstName ?? ''} ${user?.lastName ?? ''}'.trim(),
          senderUserId: user?.id,
          entityId: requestId,
        );
      }

      final message = response['message'] ?? 'Request accepted';
      return Right(message.toString());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> rejectCaregiverRequest({
    required String requestId,
  }) async {
    try {
      final token = await HiveService.getAccessToken();
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await apiService.patch(
        '/patients/caregiver/requests/$requestId/reject',
        {},
        headers: headers,
      );

      if (response is ServerFailure) {
        return Left(response);
      }

      final message = response['message'] ?? 'Request rejected';
      return Right(message.toString());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, List<ManagedPatientSummary>>> listManagedPatients() async {
    try {
      final token = await HiveService.getAccessToken();
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      Future<dynamic> fetch(String endpoint) async {
        return apiService.get(endpoint, headers: headers);
      }

      var response = await fetch('/patients/caregiver/patients');
    

      if (response is ServerFailure) {
        return Left(response);
      }
      log('List Managed Patients Response: ${response.toString()}');
      final patientsJson =
          (response['patients'] as List<dynamic>?) ??
          (response['managedPatients'] as List<dynamic>?) ??
          (response['data'] as List<dynamic>?) ??
          const [];

      final patients = patientsJson
          .whereType<Map<String, dynamic>>()
          .map(ManagedPatientSummary.fromJson)
          .toList();

      return Right(patients);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, List<DoctorRequestModel>>>
  listDoctorRequests() async {
    try {
      final token = await HiveService.getAccessToken();
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await apiService.get(
        '/patients/doctor-requests',
        headers: headers,
      );
      log('List Doctor Requests Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final requestsJson = (response['requests'] as List<dynamic>? ?? []);
      final requests = requestsJson
          .whereType<Map<String, dynamic>>()
          .map(DoctorRequestModel.fromJson)
          .toList();

      return Right(requests);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> acceptDoctorRequest({
    required String doctorId,
    String? doctorFcmToken,
  }) async {
    try {
      final token = await HiveService.getAccessToken();
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await apiService.patch(
        '/patients/connected-doctors/accept/$doctorId',
        {},
        headers: headers,
      );
      log('Accept Doctor Request Response: ${response.toString()}');
      if (response is ServerFailure) {
        return Left(response);
      }

      if (doctorFcmToken != null && doctorFcmToken.trim().isNotEmpty) {
        final user = await HiveService.getUserData();
        await _notificationDispatchService.sendDoctorRequestAccepted(
          recipientFcmToken: doctorFcmToken,
          doctorName: '${user?.firstName ?? ''} ${user?.lastName ?? ''}'.trim(),
          recipientUserId: doctorId,
          senderName: '${user?.firstName ?? ''} ${user?.lastName ?? ''}'.trim(),
          senderUserId: user?.id,
          entityId: doctorId,
        );
      }

      final message = response['message'] ?? 'Doctor request accepted';
      return Right(message.toString());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> rejectDoctorRequest({
    required String doctorId,
  }) async {
    try {
      final token = await HiveService.getAccessToken();
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await apiService.patch(
        '/patients/connected-doctors/reject/$doctorId',
        {},
        headers: headers,
      );
      log('Reject Doctor Request Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final message = response['message'] ?? 'Doctor request rejected';
      return Right(message.toString());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

 @override
  Future<Either<ApiError, String>> exportHealthPassportPDF({
    required String apiEndpoint,
  }) async {
    try {
      final token = await HiveService.getAccessToken();

      final response = await apiService.downloadFile(
        apiEndpoint,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      log('PDF export response status: ${response.statusCode}');
      log('PDF export content-type: ${response.headers.value('content-type')}');

      final downloadDirectory = await _resolveDownloadsDirectory();
      final fileName =
          'patient_record_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final filePath = '${downloadDirectory.path}/$fileName';

      final file = File(filePath);
      await file.writeAsBytes(List<int>.from(response.data));

      log('PDF saved at: $filePath');

      return Right(filePath);
    } on DioException catch (e, stackTrace) {
      log('PDF export DioException: ${e.message}', stackTrace: stackTrace);
      return Left(ServerFailure.fromDioError(e));
    } catch (e, stackTrace) {
      log('PDF export error: $e', stackTrace: stackTrace);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> generateQRToken() async {
    try {
      final token = await HiveService.getAccessToken();

      final response = await apiService.post(
        '/export/qr-token',
        {},
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      log('Generate QR Token Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final qrToken = response['qrToken'] ?? response['token'] ?? '';
      return Right(qrToken.toString());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> downloadSharedRecord({
    required String qrToken,
  }) async {
    try {
      final response = await apiService.downloadFile(
        '/export/shared/$qrToken',
      );

      log('Shared record download status: ${response.statusCode}');

      final downloadDirectory = await _resolveDownloadsDirectory();
      final fileName =
          'health_record_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final filePath = '${downloadDirectory.path}/$fileName';

      final file = File(filePath);
      await file.writeAsBytes(List<int>.from(response.data));

      log('Shared record saved at: $filePath');

      return Right(filePath);
    } on DioException catch (e, stackTrace) {
      log('Shared record download DioException: ${e.message}',
          stackTrace: stackTrace);
      return Left(ServerFailure.fromDioError(e));
    } catch (e, stackTrace) {
      log('Shared record download error: $e', stackTrace: stackTrace);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ApiError, String>> completePatientProfile({
    required String phone,
    required int yearOfBirth,
    required String gender,
    List<String>? chronicConditions,
    List<String>? longTermMedication,
    List<String>? allergies,
    bool? reactionToMedication,
    bool? allergyAlerts,
    String? bloodType,
  }) async {
    try {
      final token = await HiveService.getAccessToken();
      final data = {
        'phone': phone,
        'yearOfBirth': yearOfBirth,
        'gender': gender,
        'chronicConditions': chronicConditions,
        'longTermMedication': longTermMedication,
        'allergies': allergies,
        'reactionToMedication': reactionToMedication,
        'allergyAlerts': allergyAlerts,
        'bloodType': bloodType,
      }..removeWhere((key, value) => value == null);

      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };
 log('Complete Patient Profile Request Data: ${data.toString()}');
      final dynamic response = await apiService.patch(
        '/patients/complete',
        data,
        headers: headers,
      );

      log('Complete Patient Profile Response: ${response.toString()}');

      if (response is ServerFailure) {
        return Left(response);
      }

      final message = response['message'] ?? 'Patient profile completed successfully';
      return Right(message);
    } on DioException catch (e) {
      final serverFailure = ServerFailure.fromDioError(e);
      return Left(serverFailure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Directory> _resolveDownloadsDirectory() async {
  if (Platform.isAndroid) {

    // Android 10 وأقل
    final androidApiLevel = _androidApiLevel();

    if (androidApiLevel != null && androidApiLevel <= 28) {
      final status = await Permission.storage.request();

      if (!status.isGranted) {
        throw Exception('Storage permission denied');
      }
    }

    final directory = Directory('/storage/emulated/0/Download');

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    return directory;
  }

  // iOS / Desktop
  final directory = await getDownloadsDirectory();

  if (directory == null) {
    throw Exception('Unable to resolve Downloads directory');
  }

  return directory;
}

  int? _androidApiLevel() {
    if (!Platform.isAndroid) return null;

    final match = RegExp(r'API (\d+)').firstMatch(Platform.operatingSystemVersion);
    return int.tryParse(match?.group(1) ?? '');
  }
}
