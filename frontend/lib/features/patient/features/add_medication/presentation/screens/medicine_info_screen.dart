import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';
import 'package:medi/features/patient/features/add_medication/data/repo/medicine_repo.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medicine_info_cubit.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medicine_info_state.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/critical_mode_card.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/delete_button.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/medicine_header_card.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/notes_card.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/refill_stock_dialog.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/schedule_card.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/side_effects_card.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/stock_expiry_card.dart';
import 'package:medi/features/patient/features/add_medication/presentation/screens/daily_symptoms_screen.dart';

class MedicineInfoScreen extends StatelessWidget {
  const MedicineInfoScreen({super.key, this.medication});

  final Medication? medication;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          MedicineInfoCubit(getIt<MedicineRepo>(), medication: medication),
      child: const _MedicineInfoView(),
    );
  }
}

class _MedicineInfoView extends StatelessWidget {
  const _MedicineInfoView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: BlocListener<MedicineInfoCubit, MedicineInfoState>(
        listenWhen: (previous, current) =>
            previous.isDeleted != current.isDeleted && current.isDeleted,
        listener: (context, state) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Medication deleted successfully'),
              backgroundColor: const Color(0xFF34C759),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.all(AppSizes.w16),
            ),
          );

          context.pop();
        },
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                elevation: 0,
                pinned: true,
                centerTitle: true,
                leading: _BackButton(),
                title: Text(
                  'Medicine Info',
                  style: TextStyle(
                    fontSize: AppSizes.sp18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
                actions: [
                  GestureDetector(
                    child: SvgPicture.asset(AppAssets.edit),
                    onTap: () async {
                      final cubit = context.read<MedicineInfoCubit>();
                      final updated = await context.push<Medication>(
                        AppRouter.editMedicationScreen,
                        extra: cubit.state.medication,
                      );
                      if (updated != null && context.mounted) {
                        await cubit.applyEditedMedication(updated);
                      }
                    },
                  ),
                ],
                actionsPadding: EdgeInsets.only(right: AppSizes.w12),
              ),

              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  AppSizes.w16,
                  AppSizes.h8,
                  AppSizes.w16,
                  AppSizes.h24,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    BlocSelector<
                      MedicineInfoCubit,
                      MedicineInfoState,
                      (String, String, MedicationType)
                    >(
                      selector: (state) => (
                        state.medicineName,
                        state.medicineSubtitle,
                        state.medicationType,
                      ),
                      builder: (context, viewData) {
                        return MedicineHeaderCard(
                          imagePath: AppAssets.getMedicineIcon(viewData.$3),
                          medicineName: viewData.$1,
                          subtitle: viewData.$2,
                        );
                      },
                    ),
                    SizedBox(height: AppSizes.h16),
                    BlocSelector<MedicineInfoCubit, MedicineInfoState, bool>(
                      selector: (state) => state.criticalMode,
                      builder: (context, criticalMode) {
                        return CriticalModeCard(
                          enabled: criticalMode,
                          onChanged: context
                              .read<MedicineInfoCubit>()
                              .toggleCriticalMode,
                        );
                      },
                    ),
                    SizedBox(height: AppSizes.h16),
                    BlocSelector<
                      MedicineInfoCubit,
                      MedicineInfoState,
                      (int, String)
                    >(
                      selector: (state) => (state.stock, state.expiryDate),
                      builder: (context, stockData) {
                        return StockExpiryCard(
                          stock: stockData.$1,
                          expiryDate: stockData.$2,
                          onRefill: () => showRefillStockDialog(
                            context,
                            onSave: (amount) async {
                              final result = await context
                                  .read<MedicineInfoCubit>()
                                  .refillStock(amount: amount);

                              return result.fold((error) {
                                if (!context.mounted) return false;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(error.message),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return false;
                              }, (_) => true);
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: AppSizes.h16),
                    BlocSelector<
                      MedicineInfoCubit,
                      MedicineInfoState,
                      (
                        List<String>,
                        String,
                        String,
                        List<MedicationScheduleTime>,
                      )
                    >(
                      selector: (state) => (
                        state.reminders,
                        state.frequency,
                        state.duration,
                        state.scheduleTimes,
                      ),
                      builder: (context, scheduleData) {
                        return ScheduleCard(
                          reminders: scheduleData.$1,
                          scheduleTimes: scheduleData.$4,
                          frequency: scheduleData.$2,
                          duration: scheduleData.$3,
                          onReminderTakenChanged: (time, value) async {
                            await _handleReminderTakenChanged(
                              context,
                              time: time,
                              value: value,
                            );
                          },
                          onAddPressed: context
                              .read<MedicineInfoCubit>()
                              .addScheduleItem,
                        );
                      },
                    ),
                    SizedBox(height: AppSizes.h16),
                    BlocSelector<
                      MedicineInfoCubit,
                      MedicineInfoState,
                      List<String>
                    >(
                      selector: (state) => state.sideEffects,
                      builder: (context, sideEffects) {
                        if (sideEffects.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Column(
                          children: [
                            SideEffectsCard(sideEffects: sideEffects),
                            SizedBox(height: AppSizes.h16),
                          ],
                        );
                      },
                    ),
                    BlocSelector<MedicineInfoCubit, MedicineInfoState, String>(
                      selector: (state) => state.notes,
                      builder: (context, notes) {
                        return NotesCard(notes: notes);
                      },
                    ),
                    SizedBox(height: AppSizes.h24),
                    DeleteButton(
                      onConfirmedDelete: () async {
                        final result = await context
                            .read<MedicineInfoCubit>()
                            .deleteMedication();
                        result.fold((error) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error.message),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }, (_) {});
                      },
                    ),
                    SizedBox(height: AppSizes.h120),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmTakenTime(BuildContext context, String time) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirm taken time'),
          content: Text('Mark $time as taken?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<void> _handleReminderTakenChanged(
    BuildContext context, {
    required String time,
    required bool value,
  }) async {
    final selectedTime = time.trim();
    if (selectedTime.isEmpty || selectedTime == '--:--') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No schedule time available')),
      );
      return;
    }

    if (value) {
      final confirmed = await _confirmTakenTime(context, selectedTime);
      if (!confirmed || !context.mounted) {
        return;
      }
    }

    final cubit = context.read<MedicineInfoCubit>();
    final result = await cubit.toggleMedicineTaken(value, time: selectedTime);

    result.fold(
      (error) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message), backgroundColor: Colors.red),
        );
      },
      (_) {
        if (!context.mounted) return;
        if (value) {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) =>
                  DailySymptomsScreen(medicationId: cubit.state.medication.id),
            ),
          );
        }
      },
    );
  }
}

class _BackButton extends StatefulWidget {
  @override
  State<_BackButton> createState() => _BackButtonState();
}

class _BackButtonState extends State<_BackButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) {
        setState(() => _pressed = false);
        Navigator.of(context).pop();
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 100),
        scale: _pressed ? 0.9 : 1,
        child: Container(
          margin: EdgeInsets.all(AppSizes.w8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: Color(0xFF1F2937),
          ),
        ),
      ),
    );
  }
}
