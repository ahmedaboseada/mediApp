import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/utils/app_them.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:medi/core/constants/app_keys.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStartupInitializer.initializeCoreServices();
  await Firebase.initializeApp();

  /// 1.1.2: set navigator key to ZegoUIKitPrebuiltCallInvitationService
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
   ZIMKit().init(
    appID: AppKeys.chatAppId, // your appid
    appSign: AppKeys.chatAppSign, // your appSign
  );

  /// call the useSystemCallingUI
  await ZegoUIKit().initLog().then((value) async {
    await ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI([
      ZegoUIKitSignalingPlugin(),
    ]);

      // If we have a saved user from previous session, initialize the
      // invitation service now so that incoming/outgoing invitations work
      // immediately on app start.
      try {
        final savedUser = HiveService.getUserData();
        if (savedUser != null) {
          await ZegoUIKitPrebuiltCallInvitationService().init(
            appID: AppKeys.appId,
            appSign: AppKeys.appSign,
            userID: savedUser.id,
            userName: '${savedUser.firstName} ${savedUser.lastName}',
            plugins: [ZegoUIKitSignalingPlugin()],
          );
        }
      } catch (e) {
        // Don't block startup if Zego init fails; log for debugging.
        // ignore: avoid_print
        print('[Zego] PrebuiltCallInvitationService init failed: $e');
      }
    // Setup authentication failure callback for DioClient
    final dioClient = getIt<ApiService>().dioClient;
    dioClient.setOnAuthFailureCallback(() async {
      // Navigate to role selection screen when authentication fails
      try {
        final context = navigatorKey.currentContext;
        if (context != null && context.mounted) {
          GoRouter.of(context).go(AppRouter.selectScreen);
        }
      } catch (e) {
        print('[Auth] Error navigating to role selection: $e');
      }
    });

    runApp(const medi());
  });
}

class medi extends StatefulWidget {
  const medi({super.key});

  @override
  State<medi> createState() => _MediState();
}

class _MediState extends State<medi> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ZegoUIKitPrebuiltCallInvitationService().enterAcceptedOfflineCall();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          theme: lightTheme,
          //ThemeData(scaffoldBackgroundColor: Color(0xFFF5F7FB)), new login suignup pages
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
