import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:horizontal_calender_mz/horizontal_calender_mz.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/add_medication/data/repo/medicine_repo.dart';
import 'package:medi/features/patient/features/home/presentation/controller/schedule/schedule_cubit.dart';

class YourSchedule extends StatelessWidget {
  YourSchedule({super.key});

  final ValueNotifier<DateTime?> _selectedDate = ValueNotifier<DateTime?>(
    DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScheduleCubit>(
      create: (_) =>
          ScheduleCubit(getIt<MedicineRepo>())..loadForSelectedDate(),
      child: Builder(
        builder: (blocContext) => Card(
          color: const Color(0xFFF3F6FD),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.r24),
          ),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(AppSizes.h24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HorizontalCalenderMZ(
                    selectedbgcolor: AppColors.primary,
                    header: Text(
                      'Your Schedule',
                      style: AppStyles.black24700.copyWith(
                        fontSize: AppSizes.sp20,
                      ),
                    ),
                    selectedDate: _selectedDate,
                    startyear: DateTime.now().year - 2,
                    endyear: DateTime.now().year + 2,
                    footer: false,
                    onDateSelected: (selectedDate) {
                      _selectedDate.value = selectedDate;
                      blocContext.read<ScheduleCubit>().selectDate(
                        selectedDate,
                      );
                    },
                  ),
                  SizedBox(height: AppSizes.h18),
                  BlocBuilder<ScheduleCubit, ScheduleState>(
                    builder: (context, state) {
                      if (state is ScheduleLoading) {
                        return SizedBox(
                          height: AppSizes.h120,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (state is ScheduleFailure) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: AppSizes.h16),
                          child: Text(
                            state.message,
                            style: AppStyles.secondary12400,
                          ),
                        );
                      }

                      if (state is ScheduleSuccess) {
                        if (state.medications.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: AppSizes.h16,
                            ),
                            child: Text(
                              'No medication schedule for this day.',
                              style: AppStyles.secondary12400,
                            ),
                          );
                        }

                        return SizedBox(
                          height: AppSizes.h150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.medications.length,
                            itemBuilder: (context, index) {
                              final medication = state.medications[index];
                              return Padding(
                                padding: EdgeInsets.only(right: AppSizes.w12),
                                child: SizedBox(
                                  width: AppSizes.w160,
                                  child: _MedicationScheduleCard(
                                    key: ValueKey(
                                      '${medication.id}-${medication.primaryTime}-${state.selectedDate.toIso8601String()}',
                                    ),
                                    medication: medication,
                                    selectedDate: state.selectedDate,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MedicationScheduleCard extends StatelessWidget {
  const _MedicationScheduleCard({
    super.key,
    required this.medication,
    required this.selectedDate,
  });

  final ScheduleMedication medication;
  final DateTime selectedDate;

  Future<void> _cancelReminderForPrimaryTime(BuildContext context) async {
    if (medication.primaryTime == '--:--') {
      return;
    }

    final errorMessage = await context
        .read<ScheduleCubit>()
        .cancelPrimaryReminderNotification(medication);

    if (!context.mounted) {
      return;
    }

    if (errorMessage != null && errorMessage.trim().isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  Future<void> _markPrimaryTimeAsTaken(BuildContext context) async {
    if (medication.isTaken) {
      return;
    }

    final errorMessage = await context
        .read<ScheduleCubit>()
        .markPrimaryTimeAsTaken(medication);

    if (!context.mounted) {
      return;
    }

    if (errorMessage != null && errorMessage.trim().isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMuted = context.select<ScheduleCubit, bool>(
      (cubit) => cubit.isPrimaryReminderMuted(medication),
    );

    return Container(
      padding: EdgeInsets.all(AppSizes.w14),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(AppSizes.r20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final textWidth =
                  (constraints.maxWidth - AppSizes.w24 - AppSizes.w12)
                      .clamp(0.0, double.infinity)
                      .toDouble();

              return Row(
                children: [
                  SizedBox(
                    width: AppSizes.w24,
                    height: AppSizes.h24,
                    child: _buildMedicationIcon(),
                  ),
                  SizedBox(width: AppSizes.w12),
                  SizedBox(
                    width: textWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          medication.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.black16400,
                        ),
                        SizedBox(height: AppSizes.h4),
                        Text(
                          medication.dosage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.secondary12400,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: AppSizes.h10),

          if (medication.isCritical)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.w10,
                vertical: AppSizes.h4,
              ),
              decoration: BoxDecoration(
                color: AppColors.medicineCriticalBadgeBackground,
                borderRadius: BorderRadius.circular(AppSizes.r16),
              ),
              child: Text(
                'Critical',
                style: AppStyles.white14500.copyWith(fontSize: AppSizes.sp12),
              ),
            )
          else
            Expanded(child: SizedBox(height: AppSizes.h8)),
          if (medication.isCritical) SizedBox(height: AppSizes.h4),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.w8,
                  vertical: AppSizes.h4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(AppSizes.r24),
                  border: Border.all(color: AppColors.surfaceColor, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: AppSizes.w24,
                        maxHeight: AppSizes.h24,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.whiteText,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: InkWell(
                          onTap: () => _cancelReminderForPrimaryTime(context),
                          borderRadius: BorderRadius.circular(AppSizes.r24),
                          child: Icon(
                            isMuted
                                ? Icons.volume_off_rounded
                                : Icons.volume_up_rounded,
                            color: AppColors.primaryDark,
                            size: AppSizes.h10,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSizes.w8),
                    Text(
                      medication.primaryTime,
                      style: AppStyles.primaryDark12400,
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSizes.w8),
              InkWell(
                onTap: () => _markPrimaryTimeAsTaken(context),
                borderRadius: BorderRadius.circular(AppSizes.r20),
                child: CircleAvatar(
                  radius: AppSizes.r20,
                  backgroundColor: medication.isTaken
                      ? AppColors.success
                      : AppColors.greyLight,
                  child: Icon(
                    Icons.check,
                    color: AppColors.surfaceColor,
                    size: AppSizes.sp20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationIcon() {
    final iconPath = AppAssets.getMedicineIcon(medication.type);

    if (iconPath.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        iconPath,
        width: AppSizes.w24,
        height: AppSizes.h24,
      );
    }

    return Image.asset(iconPath, width: AppSizes.w24, height: AppSizes.h24);
  }
}
