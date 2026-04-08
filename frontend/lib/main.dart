import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/utils/app_them.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive before anything else
  await HiveService.init();
  await LocalNotificationService.init();
  await AndroidAlarmManager.initialize();

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
