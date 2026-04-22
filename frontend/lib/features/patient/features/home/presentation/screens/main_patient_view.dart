import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/home/presentation/controller/schedule/home_schedule_refresh_bus.dart';

class MainPatientView extends StatelessWidget {
  const MainPatientView({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final navItems = [
      NavItem(icon: AppAssets.home, label: "Home", index: 0),
      NavItem(icon: AppAssets.pills, label: "Medicine", index: 1),
      NavItem(icon: AppAssets.docs, label: "Doctors", index: 2),
      NavItem(icon: AppAssets.chats, label: "Chat", index: 3),
      NavItem(icon: AppAssets.profile, label: "Profile", index: 4),
    ];

    return Scaffold(
      body: shell,
      extendBody: true,
      bottomNavigationBar: AdvancedBottomNavBar(
        items: navItems,
        currentIndex: shell.currentIndex,
        onTap: (index) {
          shell.goBranch(index, initialLocation: index == shell.currentIndex);
          if (index == 0) {
            HomeScheduleRefreshBus.notifyRefresh();
          }
        },
        selectedColor: AppColors.primary,
      ),
    );
  }
}

// class MainPatientView extends StatelessWidget {
//   const MainPatientView({super.key, required this.child});

//   final Widget child;

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => PatientFlowCubit(),
//       child: const _MainPatientView(),
//     );
//   }
// }

// class _MainPatientView extends StatelessWidget {
//   const _MainPatientView();

//   @override
//   Widget build(BuildContext context) {
//     final currentTab = context.watch<PatientFlowCubit>().state;

//     final navItems = [
//       NavItem(icon: AppAssets.home, label: "Home", index: 0),
//       NavItem(icon: AppAssets.pills, label: "Medicine", index: 1),
//       NavItem(icon: AppAssets.docs, label: "Doctors", index: 2),
//       NavItem(icon: AppAssets.chats, label: "Chat", index: 3),
//       NavItem(icon: AppAssets.profile, label: "Profile", index: 4),
//     ];
//     return BlocBuilder<PatientFlowCubit, PatientTab>(
//       builder: (context, state) {
//         return Scaffold(
//           extendBody: true,

//           body: child,
//           // switch (state) {
//           //   PatientTab.home => Container(color: Colors.red),
//           //   PatientTab.medicine => const SizedBox.shrink(),

//           //   PatientTab.doctor => Container(color: Colors.blue),
//           //   PatientTab.chat => Container(color: Colors.yellow),
//           //   PatientTab.profile => MultiBlocProvider(
//           //     providers: [
//           //       BlocProvider(create: (_) => getIt<ProfileCubit>()),
//           //       BlocProvider(create: (_) => LogOutCubit(getIt<AuthRepoImpl>())),
//           //     ],
//           //     child: const ProfileScreen(),
//           //   ),
//           // },
//           bottomNavigationBar: AdvancedBottomNavBar(
//             items: navItems,
//             currentIndex: currentTab.index,
//             onTap: (index) {
//               context.read<PatientFlowCubit>().changeTab(
//                 PatientTab.values[index],
//               );
//               if (index == 1) {
//                 context.go('/patient/addMedication/chooseMethod');
//               }
//             },
//             selectedColor: AppColors.primary,
//           ),
//         );
//       },
//     );
//   }
// }
