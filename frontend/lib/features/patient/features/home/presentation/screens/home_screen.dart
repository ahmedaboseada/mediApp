import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/add_medication/data/repo/medicine_repo.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medicine_cubit.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/floating_actions_menu.dart';
import 'package:medi/features/patient/features/home/presentation/widgets/health_summary.dart';
import 'package:medi/features/patient/features/home/presentation/widgets/upcoming_booking.dart';
import 'package:medi/features/patient/features/home/presentation/widgets/user_widget.dart';
import 'package:medi/features/patient/features/home/presentation/widgets/your_schedule.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final List<String> selected = <String>[];

  @override
  Widget build(BuildContext context) {
    final user = HiveService.getUserData();
    final firstName = user?.firstName.trim() ?? '';
    final profileImagePath = user?.profilePicture ?? '';

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(AppSizes.h16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          UserWidget(
                            firstName: firstName,
                            profileImagePath: profileImagePath,
                          ),
                          GestureDetector(
                            onTap: () {
                              final emergency =
                                  HiveService.getEmergencyContact();

                              if (emergency == null ||
                                  (emergency['name'] as String?)?.isEmpty ==
                                      true) {
                                // No contact saved yet - open set contact screen
                                context.push(
                                  AppRouter.setEmergencyContactscreen,
                                );
                              } else {
                                // Contact exists - open confirm screen with details
                                final name = emergency['name'] as String? ?? '';
                                final method =
                                    emergency['contactMethod'] as String? ??
                                    'whatsapp';
                                context.push(
                                  AppRouter.confirmEmergencyAlertScreen,
                                  extra: {
                                    'contactName': name,
                                    'contactMethod': method,
                                  },
                                );
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (c) => ConfirmEmergencyAlertScreen(
                                //       contactName: name,
                                //       contactMethod: method,
                                //     ),
                                //   ),
                                // );
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSizes.w8,
                                vertical: AppSizes.h6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(
                                  AppSizes.r40,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: AppColors.surfaceColor,
                                  ),
                                  Text(' SOS', style: AppStyles.white14500),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    YourSchedule(),
                    HealthSummary(),
                    UpcomingBooking(),
                    SizedBox(height: AppSizes.h120),
                  ],
                ),
              ),
            ),
            Positioned(
              right: AppSizes.w16,
              bottom: AppSizes.h160,
              child: BlocProvider<MedicineCubit>(
                create: (_) => MedicineCubit(getIt<MedicineRepo>()),
                child: const FloatingActionsMenu(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
