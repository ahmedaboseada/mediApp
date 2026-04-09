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
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final accessToken = HiveService.getAccessToken();
    final userRole = HiveService.getUserRole();
    final isOnboardingCompleted = HiveService.isOnboardingCompleted();

    if (accessToken != null && accessToken.isNotEmpty) {
      // User is logged in, go to home based on role
      if (mounted) {
        if (userRole == UserRole.doctor) {
          context.go(AppRouter.mainLayout);
        } else {
          context.go('/home');
        }
      }
    } else if (!isOnboardingCompleted) {
      // First time user, show onboarding
      if (mounted) {
        context.go(AppRouter.onboardingScreen);
      }
    } else {
      // Onboarding completed but not logged in, show welcome/sign in
      if (mounted) {
        context.go(AppRouter.selectScreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Image.asset(AppAssets.welcomPng),
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
