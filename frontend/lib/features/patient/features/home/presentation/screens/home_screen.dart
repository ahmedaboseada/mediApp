
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:alarm/alarm.dart';
import 'package:medi/features/patient/features/add_medication/data/repo/medicine_repo.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medicine_cubit.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/floating_actions_menu.dart';
import 'package:medi/features/patient/features/home/presentation/widgets/health_summary.dart';
import 'package:medi/features/patient/features/home/presentation/widgets/user_widget.dart';
import 'package:medi/features/patient/features/home/presentation/widgets/your_schedule.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final List<String> selected = <String>[];

  Future<void> _setAlarm(BuildContext context, AlarmSettings settings) async {
    try {
      await Alarm.set(alarmSettings: settings);
     
    
    } on MissingPluginException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alarm plugin is not available. Please do a full app restart.'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to set alarm: $e')),
      );
    }
  }

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
                          Container(
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
                                Text(' SOS', style: AppStyles.white14500),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                   
                    YourSchedule(),
                    HealthSummary(),
                    
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
