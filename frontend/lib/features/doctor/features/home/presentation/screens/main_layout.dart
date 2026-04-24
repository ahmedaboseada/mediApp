import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/home/presentation/cubit/cubit/home_nav_cubit_cubit.dart';
import 'package:medi/features/doctor/features/home/presentation/screens/chat_screen.dart';
import 'package:medi/features/doctor/features/home/presentation/screens/profile_screen.dart';
import 'package:medi/features/doctor/features/home/presentation/screens/home_screen.dart';
import 'package:medi/features/doctor/features/patients/presentation/screens/patients_screen.dart';

import 'package:medi/features/shared/auth/presentation/cubit/user_profile/user_profile_cubit.dart';
import 'package:medi/features/shared/auth/data/repo/auth_repo_impl.dart';

class MainDoctorView extends StatelessWidget {
  const MainDoctorView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserProfileCubit(getIt<AuthRepoImpl>())..getMe(),
        ),
        BlocProvider(
          create: (_) => HomeNavCubit(),
        ),
      ],
      child: const _MainLayoutView(),
    );
  }
}

class _MainLayoutView extends StatelessWidget {
  const _MainLayoutView();

  @override
  Widget build(BuildContext context) {
    final currentTab = context.watch<HomeNavCubit>().state;

    final navItems = [
      NavItem(icon: AppAssets.home, label: "Home", index: 0),
      NavItem(icon: AppAssets.docs, label: "Patients", index: 1),
      NavItem(icon: AppAssets.chats, label: "Chat", index: 2),
      NavItem(icon: AppAssets.profile, label: "Profile", index: 3),
    ];

    return Scaffold(
      extendBody: true,
      body: BlocBuilder<HomeNavCubit, HomeTab>(
        builder: (context, tab) {
          return switch (tab) {
            HomeTab.home => HomeScreen(),
            HomeTab.doctor => const PatientsScreen(),
            HomeTab.chat => const ChatScreen(),
            HomeTab.profile => const ProfileScreen(),
          };
        },
      ),
      bottomNavigationBar: AdvancedBottomNavBar(
        items: navItems,
        currentIndex: currentTab.index,
        onTap: (index) {
          context.read<HomeNavCubit>().changeTab(HomeTab.values[index]);
        },
        selectedColor: AppColors.primary,
      ),
    );
  }
}
