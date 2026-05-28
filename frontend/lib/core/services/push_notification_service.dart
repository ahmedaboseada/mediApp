import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:medi/core/services/local_notification_service.dart';
import 'package:medi/core/services/notification_inbox_service.dart';

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
  static void sendTokenToServer(String token) {}
}