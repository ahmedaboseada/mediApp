import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi/core/core.dart';
import 'package:alarm/alarm.dart';
import 'package:medi/core/utils/app_them.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive before anything else
  await HiveService.init();
  
  // Initialize notifications with error handling for missing plugins
  try {
    await LocalNotificationService.init();
  } on MissingPluginException catch (e) {
    debugPrint('Notification plugin initialization failed: $e');
  } catch (e) {
    debugPrint('Unexpected error during notification init: $e');
  }
  
  // Initialize alarm manager with error handling
  try {
    await AndroidAlarmManager.initialize();
  } on MissingPluginException catch (e) {
    debugPrint('Alarm manager initialization failed: $e');
  } catch (e) {
    debugPrint('Unexpected error during alarm manager init: $e');
  }
  
  // Initialize Alarm package (includes flutter_fgbg) with error handling
  try {
    await Alarm.init();
    await LocalNotificationService.cleanupLegacyWarningAlarms();
    debugPrint('✓ Alarm package initialized successfully');
  } on MissingPluginException catch (e) {
    debugPrint('Alarm plugin initialization failed (flutter_fgbg unavailable): $e');
  } catch (e) {
    debugPrint('Unexpected error during alarm init: $e');
  }

  await setupServiceLocator();
  runApp(const medi());
}

class medi extends StatelessWidget {
  const medi({super.key});

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
