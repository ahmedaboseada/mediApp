enum NotificationEventType {
  medicationAdded,
  medicationUpdated,
  medicationDeleted,
  doctorRequestSent,
  doctorRequestAccepted,
  caregiverRequestSent,
  caregiverRequestAccepted,
}

extension NotificationEventTypeValue on NotificationEventType {
  String get value {
    switch (this) {
      case NotificationEventType.medicationAdded:
        return 'medication_added';
      case NotificationEventType.medicationUpdated:
        return 'medication_updated';
      case NotificationEventType.medicationDeleted:
        return 'medication_deleted';
      case NotificationEventType.doctorRequestSent:
        return 'doctor_request_sent';
      case NotificationEventType.doctorRequestAccepted:
        return 'doctor_request_accepted';
      case NotificationEventType.caregiverRequestSent:
        return 'caregiver_request_sent';
      case NotificationEventType.caregiverRequestAccepted:
        return 'caregiver_request_accepted';
    }
  }
}

class NotificationDispatchRequest {
  const NotificationDispatchRequest({
    required this.recipientFcmToken,
    required this.title,
    required this.body,
    required this.eventType,
    this.senderUserId,
    this.senderRole,
    this.senderName,
    this.recipientUserId,
    this.entityType,
    this.entityId,
    this.entityName,
    this.data = const <String, dynamic>{},
  });

  final String recipientFcmToken;
  final String title;
  final String body;
  final NotificationEventType eventType;
  final String? senderUserId;
  final String? senderRole;
  final String? senderName;
  final String? recipientUserId;
  final String? entityType;
  final String? entityId;
  final String? entityName;
  final Map<String, dynamic> data;

  Map<String, dynamic> toJson() {
    return {
      'message': {
        'token': recipientFcmToken,
        'notification': {
          'title': title,
          'body': body,
        },
        'data': {
          'eventType': eventType.value,
          if (senderUserId != null) 'senderUserId': senderUserId,
          if (senderRole != null) 'senderRole': senderRole,
          if (senderName != null) 'senderName': senderName,
          if (recipientUserId != null) 'recipientUserId': recipientUserId,
          if (entityType != null) 'entityType': entityType,
          if (entityId != null) 'entityId': entityId,
          if (entityName != null) 'entityName': entityName,
          ...data.map((key, value) => MapEntry(key, value.toString())),
        },
      },
    };
  }
}