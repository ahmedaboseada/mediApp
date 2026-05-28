import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/services/call_service.dart';
import 'package:medi/core/services/push_notification_service.dart';
import 'package:medi/core/utils/app_them.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStartupInitializer.initializeCriticalServices();
  final dioClient = getIt<ApiService>().dioClient;
  dioClient.setOnAuthFailureCallback(() async {
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
  unawaited(_bootstrapDeferredServices());
}

Future<void> _bootstrapDeferredServices() async {
  await _runStartupTask(
    label: 'Deferred core services',
    action: AppStartupInitializer.initializeDeferredServices,
    timeout: const Duration(seconds: 20),
  );

  await _runStartupTask(
    label: 'Firebase initialization',
    action: () async {
      await Firebase.initializeApp();
    },
    timeout: const Duration(seconds: 10),
  );

  await _runStartupTask(
    label: 'Push notifications',
    action: PushNotificationService.initialize,
    timeout: const Duration(seconds: 10),
  );

  final savedUser = await HiveService.getUserData().timeout(
    const Duration(seconds: 2),
    onTimeout: () => null,
  );

  if (savedUser == null) {
    return;
  }

  await _runStartupTask(
    label: 'Call service',
    action: () async {
      await CallService.instance.init(
        userID: savedUser.id,
        userName: '${savedUser.firstName} ${savedUser.lastName}',
      );
      CallService.instance.enterAcceptedOfflineCall();
    },
    timeout: const Duration(seconds: 15),
  );
}

Future<void> _runStartupTask({
  required String label,
  required Future<void> Function() action,
  required Duration timeout,
}) async {
  try {
    await action().timeout(timeout);
  } catch (e, st) {
    debugPrint('[$label] startup skipped or failed: $e');
    debugPrintStack(stackTrace: st);
  }
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
  }

  @override
  Widget build(BuildContext context) {
    final caregiverModeCubit = getIt<CaregiverModeCubit>();
    final managedPatientDashboardCubit = getIt<ManagedPatientDashboardCubit>();

    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: caregiverModeCubit),
            BlocProvider.value(value: managedPatientDashboardCubit),
          ],
          child: MaterialApp.router(
            theme: lightTheme,
            //ThemeData(scaffoldBackgroundColor: Color(0xFFF5F7FB)), new login suignup pages
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
          ),
        );
      },
    );
  }
}
