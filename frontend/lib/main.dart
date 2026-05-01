import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/utils/app_them.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initResult = await AppStartupInitializer.initializeCoreServices();

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
