import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToNextScreen();
    });
  }

  // Future<void> _initializeAndNavigate() async {
  //   final startedAt = DateTime.now();
  //   final initResult = await AppStartupInitializer.initializeCoreServices();

  //   // Keep splash visible briefly for smoother transition and branding.
  //   const minSplashDuration = Duration(milliseconds: 1200);
  //   final elapsed = DateTime.now().difference(startedAt);
  //   if (elapsed < minSplashDuration) {
  //     await Future<void>.delayed(minSplashDuration - elapsed);
  //   }

  //   if (initResult.hadFailures) {
  //     for (final error in initResult.errors) {
  //       debugPrint(error);
  //     }
  //   }

  //   if (!mounted) return;

  //   AppStartupInitializer.initializeDeferredServices();
  //   _navigateToNextScreen();
  // }

  void _navigateToNextScreen() {
    if (!mounted) return;

    final accessToken = HiveService.getAccessToken();
    final userRole = HiveService.getUserRole();
    final isOnboardingCompleted = HiveService.isOnboardingCompleted();
    final isCompleteProfileRequired = HiveService.isCompleteProfileRequired();

    if (accessToken != null && accessToken.isNotEmpty) {
      if (isCompleteProfileRequired) {
        context.go(
          userRole == UserRole.doctor
              ? AppRouter.doctorCompleteProfile
              : AppRouter.completeProfile,
        );
        return;
      }

      // User is logged in, go to home based on role
      if (userRole == UserRole.doctor) {
        context.go(AppRouter.mainLayout);
      } else {
        context.go('/home');
      }
    } else if (!isOnboardingCompleted) {
      // First time user, show onboarding
      context.go(AppRouter.onboardingScreen);
    } else {
      // Onboarding completed but not logged in, show welcome/sign in
      context.go(AppRouter.selectScreen);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Image.asset(AppAssets.welcomPng),
                ),
              ),
            ),
            // SizedBox(height: AppSizes.h20),
            Text('Medi', style: AppStyles.splashScreenTitle),
            Text("Pill Reminder", style: AppStyles.white16600),
          ],
        ),
      ),
    );
  }
}
