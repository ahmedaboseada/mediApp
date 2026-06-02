import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:medi/core/core.dart';

class NotificationDispatchService {
  NotificationDispatchService();

  String _displayName(String? value, {String fallback = 'Someone'}) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? fallback : trimmed;
  }

  Future<Either<ApiError, String>> sendDoctorRequestToPatient({
    required String recipientFcmToken,
    required String recipientUserId,
    String? senderUserId,
    String? senderName,
    String? entityId,
  }) {
    return send(
      NotificationDispatchRequest(
        recipientFcmToken: recipientFcmToken,
        title: 'New Doctor Request',
        body: 'A doctor has requested to connect with you.',
        eventType: NotificationEventType.doctorRequestSent,
        senderUserId: senderUserId,
        senderName: senderName,
        recipientUserId: recipientUserId,
        entityType: 'patient',
        entityId: entityId,
        entityName: 'Patient',
      ),
    );
  }

  Future<Either<ApiError, String>> sendPatientAcceptedDoctorRequest({
    required String recipientFcmToken,
    required String recipientUserId,
    String? senderUserId,
    String? senderName,
    String? entityId,
  }) {
    return send(
      NotificationDispatchRequest(
        recipientFcmToken: recipientFcmToken,
        title: 'Request Approved!',
        body: 'Your doctor request has been approved.',
        eventType: NotificationEventType.doctorRequestAccepted,
        senderUserId: senderUserId,
        senderName: senderName,
        recipientUserId: recipientUserId,
        entityType: 'doctor',
        entityId: entityId,
        entityName: 'Doctor',
      ),
    );
  }

  Future<Either<ApiError, String>> send(NotificationDispatchRequest request) async {
    AutoRefreshingAuthClient? client;
    try {
      final serviceAccountJson =
          await rootBundle.loadString('assets/service-account.json');
      final decodedServiceAccount =
          jsonDecode(serviceAccountJson) as Map<String, dynamic>;

      if ((decodedServiceAccount['type'] ?? '').toString() != 'service_account') {
        throw StateError(
          'assets/service-account.json must contain a service_account credential',
        );
      }

      final credentials = ServiceAccountCredentials.fromJson(
        decodedServiceAccount,
      );
      const scopes = [
        'https://www.googleapis.com/auth/firebase.messaging',
      ];

      client = await clientViaServiceAccount(
        credentials,
        scopes,
      );

      final accessToken = client.credentials.accessToken.data;

      final url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/medi-31350/messages:send',
      );

      final message = {
        'message': {
          'token': request.recipientFcmToken,
          'notification': {
            'title': request.title,
            'body': request.body,
          },
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'eventType': request.eventType.value,
            if (request.senderUserId != null)
              'senderUserId': request.senderUserId!,
            if (request.senderRole != null)
              'senderRole': request.senderRole!,
            if (request.senderName != null)
              'senderName': request.senderName!,
            if (request.recipientUserId != null)
              'recipientUserId': request.recipientUserId!,
            if (request.entityType != null)
              'entityType': request.entityType!,
            if (request.entityId != null)
              'entityId': request.entityId!,
            if (request.entityName != null)
              'entityName': request.entityName!,
            ...request.data.map(
              (key, value) => MapEntry(key, value.toString()),
            ),
          },
        },
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(message),
      );

      log('FCM status: ${response.statusCode}, response: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final dispatchedMessage =
            (decoded is Map<String, dynamic> ? decoded['name'] : null) ??
            'Notification dispatched successfully';
        return Right(dispatchedMessage.toString());
      }

      return Left(
        ServerFailure(
          'FCM send failed (${response.statusCode}): ${response.body}',
        ),
      );
    } catch (e) {
      log('FCM send error: $e');
      return Left(ServerFailure(e.toString()));
    } finally {
      client?.close();
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