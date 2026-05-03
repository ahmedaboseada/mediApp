import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/home/presentation/screens/profile_screen_content.dart';
import 'package:medi/features/shared/auth/data/repo/auth_repo_impl.dart';
import 'package:medi/features/shared/auth/presentation/cubit/user_profile/user_profile_cubit.dart';

/// Main profile screen for doctors.
/// Handles dependency injection via BlocProvider.
/// Content rendering is delegated to ProfileScreenContent widget.
/// This follows clean architecture principles by separating:
/// - Dependency setup (here)
/// - Side effects (in content widgets via BlocListener)
/// - UI rendering (in separate content widgets)
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserProfileCubit(getIt<AuthRepoImpl>())..getMe(),
      child: const Scaffold(body: ProfileScreenContent()),
    );
  }
}
