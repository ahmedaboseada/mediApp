import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/home/presentation/controller/cubit/patient_flow_cubit.dart';
import 'package:medi/features/patient/features/profile/presentation/controller/profile/profile_cubit.dart';
import 'package:medi/features/patient/features/profile/presentation/screens/profile_screen.dart';
import 'package:medi/features/shared/auth/data/repo/auth_repo_impl.dart';
import 'package:medi/features/shared/auth/presentation/cubit/log_out/log_out_cubit.dart';

class MainPatientView extends StatelessWidget {
  const MainPatientView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PatientFlowCubit(),
      child: const _MainPatientView(),
    );
  }
}

class _MainPatientView extends StatelessWidget {
  const _MainPatientView();

  @override
  Widget build(BuildContext context) {
    final currentTab = context.watch<PatientFlowCubit>().state;

    final navItems = [
      NavItem(icon: AppAssets.home, label: "Home", index: 0),
      NavItem(icon: AppAssets.pills, label: "Medicine", index: 1),
      NavItem(icon: AppAssets.docs, label: "Doctors", index: 2),
      NavItem(icon: AppAssets.chats, label: "Chat", index: 3),
      NavItem(icon: AppAssets.profile, label: "Profile", index: 4),
    ];
    return BlocBuilder<PatientFlowCubit, PatientTab>(
      builder: (context, state) {
        return Scaffold(
          extendBody: true,

          body: switch (state) {
            PatientTab.home => Container(color: Colors.red),
            PatientTab.medicine => const SizedBox.shrink(),

            PatientTab.doctor => Container(color: Colors.blue),
            PatientTab.chat => Container(color: Colors.yellow),
            PatientTab.profile => MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => getIt<ProfileCubit>()),
                BlocProvider(create: (_) => LogOutCubit(getIt<AuthRepoImpl>())),
              ],
              child: const ProfileScreen(),
            ),
          },
          bottomNavigationBar: AdvancedBottomNavBar(
            items: navItems,
            currentIndex: currentTab.index,
            onTap: (index) {
              context.read<PatientFlowCubit>().changeTab(
                PatientTab.values[index],
              );
              if (index == 1) {
                context.go('/patient/addMedication/chooseMethod');
              }
            },
            selectedColor: AppColors.primary,
          ),
        );
      },
    );
  }
}
