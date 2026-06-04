import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:medi/core/services/notification_inbox_service.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/services/app_logger.dart';
  
class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static Future<void> initialize() async {
    // Request permission for iOS
    await messaging.requestPermission();
    messaging.getToken().then((token) {
      log('Firebase Messaging Token: $token');
      sendTokenToServer(token !);
    });
    messaging.onTokenRefresh.listen((newToken) {
      log('Firebase Messaging Token refreshed: $newToken');
      sendTokenToServer(newToken);
    });
    FirebaseMessaging.onBackgroundMessage(handleUncaughtErrorHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Received a message while in the foreground: ${message.messageId}');
      final title = message.notification?.title ?? 'New Notification';
      final body = message.notification?.body ?? 'You have a new notification';
      final data = message.data.map((key, value) => MapEntry(key, value.toString()));

      LocalNotificationService.showNotification(
        title: title,
        body: body,
        payload: message.messageId,
        category: NotificationInboxService.categoryFromMessageData(data),
       // source: NotificationSource.push,
        entityId: message.data['entityId']?.toString(),
        entityType: message.data['entityType']?.toString(),
        eventType: message.data['eventType']?.toString(),
        data: data,
      );
    });
    // // Handle foreground messages
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print('Received a message while in the foreground: ${message.messageId}');
    //   // Handle the message and show a notification if needed
    // });

    // // Handle background messages
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
  static Future<void> handleUncaughtErrorHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    log('Handling a background message: ${message.messageId}');
    final title = message.notification?.title ?? 'New Notification';
    final body = message.notification?.body ?? 'You have a new notification';
    final data = message.data.map((key, value) => MapEntry(key, value.toString()));

    await LocalNotificationService.showNotification(
      title: title,
      body: body,
      payload: message.messageId,
      category: NotificationInboxService.categoryFromMessageData(data),
    //  source: NotificationSource.push,
      entityId: message.data['entityId']?.toString(),
      entityType: message.data['entityType']?.toString(),
      eventType: message.data['eventType']?.toString(),
      data: data,
    );
  }
  static Future<void> sendTokenToServer(String token) async {
    try {
      AppLogger.instance.i('Sending FCM token to server');
      final api = getIt<ApiService>();
      final result = await api.patch('/users/fcm-token', {'fcmToken': token});
      log('FCM token update result: $result');
      if (result is ServerFailure) {
        AppLogger.instance.w('Failed to update FCM token on server: ${result.message}');
      } else {
        AppLogger.instance.i('FCM token updated on server successfully');
      }
    } catch (e, st) {
      AppLogger.instance.w('Exception while sending FCM token to server', e, st);
    }
  }
}