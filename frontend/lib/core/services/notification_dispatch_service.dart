import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:medi/core/core.dart';

class NotificationDispatchService {
  NotificationDispatchService();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.fcmBaseUrl,
      headers: const {
        'Content-Type': 'application/json',
      },
    ),
  );

  String _displayName(String? value, {String fallback = 'Someone'}) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? fallback : trimmed;
  }

  Future<Either<ApiError, String>> send(NotificationDispatchRequest request) async {
    try {
      final Response<dynamic> response = await _dio.post(
        ApiEndpoints.fcmSendMessagePath,
        data: request.toJson(),
      );

      log('Notification dispatch response: ${response.data.toString()}');

      final message =
          (response.data is Map<String, dynamic> ? response.data['message'] : null) ??
          'Notification dispatched successfully';
      return Right(message.toString());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<ApiError, String>> sendMedicationAdded({
    required String recipientFcmToken,
    required String medicationName,
    required String recipientUserId,
    String? senderUserId,
    String? senderRole,
    String? senderName,
    String? entityId,
  }) {
    return send(
      NotificationDispatchRequest(
        recipientFcmToken: recipientFcmToken,
        title: 'Medication Added',
        body: '$medicationName was added to your medications.',
        eventType: NotificationEventType.medicationAdded,
        senderUserId: senderUserId,
        senderRole: senderRole,
        senderName: senderName,
        recipientUserId: recipientUserId,
        entityType: 'medication',
        entityId: entityId,
        entityName: medicationName,
      ),
    );
  }

  Future<Either<ApiError, String>> sendMedicationUpdated({
    required String recipientFcmToken,
    required String medicationName,
    required String recipientUserId,
    String? senderUserId,
    String? senderRole,
    String? senderName,
    String? entityId,
  }) {
    return send(
      NotificationDispatchRequest(
        recipientFcmToken: recipientFcmToken,
        title: 'Medication Updated',
        body: '$medicationName was updated.',
        eventType: NotificationEventType.medicationUpdated,
        senderUserId: senderUserId,
        senderRole: senderRole,
        senderName: senderName,
        recipientUserId: recipientUserId,
        entityType: 'medication',
        entityId: entityId,
        entityName: medicationName,
      ),
    );
  }

  Future<Either<ApiError, String>> sendMedicationDeleted({
    required String recipientFcmToken,
    required String medicationName,
    required String recipientUserId,
    String? senderUserId,
    String? senderRole,
    String? senderName,
    String? entityId,
  }) {
    return send(
      NotificationDispatchRequest(
        recipientFcmToken: recipientFcmToken,
        title: 'Medication Deleted',
        body: '$medicationName was removed from your medications.',
        eventType: NotificationEventType.medicationDeleted,
        senderUserId: senderUserId,
        senderRole: senderRole,
        senderName: senderName,
        recipientUserId: recipientUserId,
        entityType: 'medication',
        entityId: entityId,
        entityName: medicationName,
      ),
    );
  }

  Future<Either<ApiError, String>> sendDoctorRequestSent({
    required String recipientFcmToken,
    required String doctorName,
    required String recipientUserId,
    String? senderUserId,
    String? senderName,
    String? entityId,
  }) {
    final actorName = _displayName(senderName);
    return send(
      NotificationDispatchRequest(
        recipientFcmToken: recipientFcmToken,
        title: 'New Connection Request',
        body: '$actorName sent you a doctor connection request.',
        eventType: NotificationEventType.doctorRequestSent,
        senderUserId: senderUserId,
        senderName: senderName,
        recipientUserId: recipientUserId,
        entityType: 'doctor',
        entityId: entityId,
        entityName: doctorName,
      ),
    );
  }

  Future<Either<ApiError, String>> sendDoctorRequestAccepted({
    required String recipientFcmToken,
    required String doctorName,
    required String recipientUserId,
    String? senderUserId,
    String? senderName,
    String? entityId,
  }) {
    return send(
      NotificationDispatchRequest(
        recipientFcmToken: recipientFcmToken,
        title: 'Doctor Request Accepted',
        body: '$doctorName accepted your request.',
        eventType: NotificationEventType.doctorRequestAccepted,
        senderUserId: senderUserId,
        senderName: senderName,
        recipientUserId: recipientUserId,
        entityType: 'doctor',
        entityId: entityId,
        entityName: doctorName,
      ),
    );
  }

  Future<Either<ApiError, String>> sendCaregiverRequestSent({
    required String recipientFcmToken,
    required String caregiverName,
    required String recipientUserId,
    String? senderUserId,
    String? senderName,
    String? entityId,
  }) {
    final actorName = _displayName(senderName);
    return send(
      NotificationDispatchRequest(
        recipientFcmToken: recipientFcmToken,
        title: 'Caregiver Request Sent',
        body: '$actorName sent you a caregiver request.',
        eventType: NotificationEventType.caregiverRequestSent,
        senderUserId: senderUserId,
        senderName: senderName,
        recipientUserId: recipientUserId,
        entityType: 'caregiver',
        entityId: entityId,
        entityName: caregiverName,
      ),
    );
  }

  Future<Either<ApiError, String>> sendCaregiverRequestAccepted({
    required String recipientFcmToken,
    required String caregiverName,
    required String recipientUserId,
    String? senderUserId,
    String? senderName,
    String? entityId,
  }) {
    return send(
      NotificationDispatchRequest(
        recipientFcmToken: recipientFcmToken,
        title: 'Caregiver Request Accepted',
        body: '$caregiverName accepted your caregiver request.',
        eventType: NotificationEventType.caregiverRequestAccepted,
        senderUserId: senderUserId,
        senderName: senderName,
        recipientUserId: recipientUserId,
        entityType: 'caregiver',
        entityId: entityId,
        entityName: caregiverName,
      ),
    );
  }
}