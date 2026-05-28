import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/home/presentation/controller/schedule/home_schedule_refresh_bus.dart';

class MainPatientView extends StatefulWidget {
  const MainPatientView({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  State<MainPatientView> createState() => _MainPatientViewState();
}

class _MainPatientViewState extends State<MainPatientView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (getIt<CaregiverModeCubit>().isManagingPatient) {
        getIt<ManagedPatientDashboardCubit>().loadManagedPatientData();
      }
    });
  }

  void _exitCaregiverMode(BuildContext context) {
    getIt<CaregiverModeCubit>().exitCaregiverMode();
    getIt<ManagedPatientDashboardCubit>().clear();
    context.go(AppRouter.patientCaregiverModeScreen);
  }

  @override
  Widget build(BuildContext context) {
    final isManagingPatient = context.watch<CaregiverModeCubit>().isManagingPatient;

    final navItems = <NavItem>[
      NavItem(icon: AppAssets.home, label: 'Home', index: 0),
      NavItem(icon: AppAssets.pills, label: 'Medicine', index: 1),
      NavItem(icon: AppAssets.docs, label: 'Doctors', index: 2),
      if (!isManagingPatient) NavItem(icon: AppAssets.chats, label: 'Chat', index: 3),
      NavItem(icon: AppAssets.profile, label: 'Profile', index: 4),
    ];

    final currentShellIndex = widget.shell.currentIndex;

    if (isManagingPatient && currentShellIndex == 3) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        widget.shell.goBranch(0);
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          widget.shell,
          BlocBuilder<ManagedPatientDashboardCubit, ManagedPatientDashboardState>(
            builder: (context, state) {
              if (!getIt<CaregiverModeCubit>().isManagingPatient) {
                return const SizedBox.shrink();
              }

              final profile = state.profile;
                final patientName = profile == null
                  ? null
                  : '${profile.user.firstName} ${profile.user.lastName}'.trim();
                final bannerText = patientName == null
                  ? 'Loading patient profile...'
                  : 'You are viewing ${patientName}\'s profile';

              return Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.all(AppSizes.w12),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.w16,
                        vertical: AppSizes.h12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF8FF),
                        borderRadius: BorderRadius.circular(AppSizes.r20),
                        border: Border.all(color: AppColors.primary.withOpacity(0.18)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                                bannerText,
                              style: AppStyles.black14500,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          TextButton(
                            onPressed: () => _exitCaregiverMode(context),
                            child: Text(
                              'Exit',
                              style: AppStyles.primaryDark12400.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: AdvancedBottomNavBar(
        items: navItems,
        currentIndex: currentShellIndex,
        onTap: (index) {
          widget.shell.goBranch(
            index,
            initialLocation: index == widget.shell.currentIndex,
          );
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
