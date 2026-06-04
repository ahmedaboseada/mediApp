import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/services/accessibility_service.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/floating_actions_menu.dart';
import 'package:medi/features/patient/features/home/presentation/widgets/health_summary.dart';
import 'package:medi/features/patient/features/home/presentation/widgets/notification_button.dart';
import 'package:medi/features/patient/features/home/presentation/widgets/upcoming_booking.dart';
import 'package:medi/features/patient/features/home/presentation/widgets/user_widget.dart';
import 'package:medi/features/patient/features/home/presentation/widgets/your_schedule.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _announced = false;

  @override
  Widget build(BuildContext context) {
    if (!_announced) {
      _announced = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AccessibilityService.announceWithRTL('Home screen');
      });
    }

    final caregiverModeCubit = getIt<CaregiverModeCubit>();

    return FutureBuilder<dynamic>(
      future: HiveService.getUserData(),
      builder: (context, snapshot) {
        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: BlocBuilder<ManagedPatientDashboardCubit, ManagedPatientDashboardState>(
              builder: (context, managedState) {
                final user = caregiverModeCubit.isManagingPatient
                    ? managedState.profile?.user
                    : snapshot.data;
                final firstName = user?.firstName.trim() ?? '';
                final profileImagePath = user?.profilePicture ?? '';

                return Stack(
                  children: [
                    Positioned.fill(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(AppSizes.h16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: UserWidget(
                                      firstName: firstName,
                                      profileImagePath: profileImagePath,
                                    ),
                                  ),
                                  SizedBox(width: AppSizes.w8),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          final emergency = await HiveService.getEmergencyContact();

                                          if (emergency == null ||
                                              (emergency['name'] as String?)?.isEmpty == true) {
                                            context.push(AppRouter.setEmergencyContactscreen);
                                          } else {
                                            final name = emergency['name'] as String? ?? '';
                                            final method = emergency['contactMethod'] as String? ?? 'whatsapp';
                                            context.push(
                                              AppRouter.confirmEmergencyAlertScreen,
                                              extra: {
                                                'contactName': name,
                                                'contactMethod': method,
                                              },
                                            );
                                          }
                                        },
                                        child: Semantics(
                                          button: true,
                                          label: 'Emergency SOS',
                                          child: Tooltip(
                                            message: 'Emergency SOS',
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: AppSizes.w8,
                                                vertical: AppSizes.h6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.error,
                                                borderRadius: BorderRadius.circular(AppSizes.r40),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.error_outline,
                                                    color: AppColors.surfaceColor,
                                                  ),
                                                  Text(
                                                    ' SOS',
                                                    style: AppStyles.white14500,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: AppSizes.w8),
                                      const NotificationButton(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            YourSchedule(key: ValueKey('schedule_${caregiverModeCubit.state}')),
                            HealthSummary(key: ValueKey('health_${caregiverModeCubit.state}')),
                            UpcomingBooking(key: ValueKey('booking_${caregiverModeCubit.state}')),
                            SizedBox(height: AppSizes.h120),
                          ],
                        ),
                      ),
                    ),

 Positioned(
              right: AppSizes.w16,
              bottom: AppSizes.h160,
              child: const FloatingActionsMenu(),
            ),                    // const FloatingActionsMenu(),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
