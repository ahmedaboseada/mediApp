/// call_service.dart
library;

import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:medi/main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zimkit/zego_zimkit.dart';
import 'package:zego_zpns/zego_zpns.dart';

import '../constants/app_keys.dart';

class CallService {
  CallService._();

  static final CallService instance = CallService._();
  bool _isZimKitInitialized = false;

  /// =========================
  /// INIT
  /// =========================

  Future<void> init({required String userID, required String userName}) async {
    try {
      /// Navigator Key
      ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

      /// Logs
      await ZegoUIKit().initLog();

      /// System Calling UI
      await ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI([
        ZegoUIKitSignalingPlugin(),
      ]);

      /// Request Permissions
      await _requestPermissions();

      /// Configure Push
      _configurePush();

      /// Listen Push Events
      _listenPushEvents();

      /// Register Offline Push
      await _registerPush();

      /// Init ZIMKit
      await ensureZimKitInitialized();

      /// Connect User
      await ZIMKit().connectUser(id: userID, name: userName);

      /// Init Call Invitation
      await ZegoUIKitPrebuiltCallInvitationService().init(
        appID: AppKeys.appId,
        appSign: AppKeys.appSign,

        userID: userID,
        userName: userName,

        plugins: [ZegoUIKitSignalingPlugin()],

        requireConfig: (ZegoCallInvitationData data) {
          if (data.invitees.length > 1) {
            return ZegoCallInvitationType.videoCall == data.type
                ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
                : ZegoUIKitPrebuiltCallConfig.groupVoiceCall();
          }

          return ZegoCallInvitationType.videoCall == data.type
              ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
              : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();
        },
      );

      log('CallService Initialized');
    } catch (e) {
      log('CallService Init Error: $e');
    }
  }

  Future<void> ensureZimKitInitialized() async {
    if (_isZimKitInitialized) {
      return;
    }

    await ZIMKit().init(appID: AppKeys.chatAppId, appSign: AppKeys.chatAppSign);
    _isZimKitInitialized = true;
  }

  /// =========================
  /// REQUEST PERMISSIONS
  /// =========================

  Future<void> _requestPermissions() async {
    await FirebaseMessaging.instance.requestPermission();

    await Permission.notification.request();

   await ZPNs.getInstance().applyNotificationPermission();
  }

  /// =========================
  /// CONFIG PUSH
  /// =========================

  void _configurePush() {
    ZPNsConfig config = ZPNsConfig();

    config.enableFCMPush = true;

    ZPNs.setPushConfig(config);
  }

  /// =========================
  /// REGISTER PUSH
  /// =========================

  Future<void> _registerPush() async {
    try {
      await ZPNs.getInstance().registerPush(
        iOSEnvironment: ZPNsIOSEnvironment.Automatic,

        iOSNotificationArrivedConfig: ZPNsIOSNotificationArrivedConfig()
          ..isPresentAlert = true
          ..isPresentBadge = true
          ..isPresentSound = true,

        enableIOSVoIP: true,
      );

      log('Offline Push Registered');
    } on PlatformException catch (e) {
      log('Register Push Error: ${e.message}');
    }
  }

  /// =========================
  /// LISTEN EVENTS
  void _listenPushEvents() {
    ZPNsEventHandler.onRegistered = (ZPNsRegisterMessage message) {
      log('PushID: ${message.pushID}');
    };

    ZPNsEventHandler.onNotificationArrived = (ZPNsMessage message) {
      log('Notification Arrived: ${message.title}');
    };

    ZPNsEventHandler.onThroughMessageReceived = (ZPNsMessage message) {
      log('Through Message: ${message.title}');
    };
  }

  /// =========================
  /// ENTER ACCEPTED OFFLINE CALL
  /// =========================

  void enterAcceptedOfflineCall() {
    ZegoUIKitPrebuiltCallInvitationService().enterAcceptedOfflineCall();
  }

  /// =========================
  /// LOGOUT
  /// =========================

  Future<void> unInit() async {
    await ZegoUIKitPrebuiltCallInvitationService().uninit();

    await ZIMKit().disconnectUser();

    log('CallService UnInitialized');
  }
}
