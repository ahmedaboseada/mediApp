import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medicine_cubit.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medicine_state.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/profile_qr.dart';

class FloatingActionsMenu extends StatelessWidget {
  const FloatingActionsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicineCubit, MedicineState>(
      buildWhen: (previous, current) =>
          previous.isFabExpanded != current.isFabExpanded,
      builder: (context, state) {
        return AnimatedMenuContainer(
          isExpanded: state.isFabExpanded,
          onMainTap: context.read<MedicineCubit>().toggleFabMenu,
          items: [
            FloatingActionItemData(
              label: AppStrings.exportHealthReport,
              icon: Icons.monitor_heart_outlined,
              backgroundColor: AppColors.medicineFabExportBackground,
              onTap: () {},
            ),
            FloatingActionItemData(
              label: AppStrings.medicationSearch,
              icon: Icons.search,
              backgroundColor: AppColors.medicineFabSearchBackground,
              onTap: () {},
            ),
            FloatingActionItemData(
              label: AppStrings.addMedication,
              icon: Icons.add_circle_outline,
              backgroundColor: AppColors.primary,
              onTap: () => context.push('/medicine/chooseMethod'),
            ),
            FloatingActionItemData(
              label: AppStrings.generateQr,
              icon: Icons.qr_code_2_outlined,
              backgroundColor: AppColors.medicineFabGenerateQrBackground,
              onTap: () => _onGenerateQrTap(context),
            ),
            FloatingActionItemData(
              label: AppStrings.chatBot,
              icon: Icons.graphic_eq,
              backgroundColor: AppColors.medicineFabChatBotBackground,
              onTap: () {},
            ),
          ],
        );
      },
    );
  }

  Future<void> _onGenerateQrTap(BuildContext context) async {
    final cubit = context.read<MedicineCubit>();

    if (cubit.state.isFabExpanded) {
      cubit.toggleFabMenu();
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final token = await cubit.generateDoctorMedicationAccessToken();

      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();

      showDialog<void>(
        context: context,
        builder: (_) => QrDialog(qrData: token),
      );
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}

class MainFloatingButton extends StatelessWidget {
  const MainFloatingButton({
    super.key,
    required this.isExpanded,
    required this.onTap,
  });

  final bool isExpanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r80),
      ),
      onPressed: onTap,
      backgroundColor: AppColors.primary,
      child: AnimatedRotation(
        turns: isExpanded ? 0.125 : 0,
        duration: const Duration(milliseconds: 250),
        child: Icon(
          isExpanded ? Icons.remove : Icons.add,
          color: AppColors.whiteText,
          size: AppSizes.sp28,
        ),
      ),
    );
  }
}

class AnimatedMenuContainer extends StatelessWidget {
  const AnimatedMenuContainer({
    super.key,
    required this.isExpanded,
    required this.onMainTap,
    required this.items,
  });

  final bool isExpanded;
  final VoidCallback onMainTap;
  final List<FloatingActionItemData> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.w200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ...List.generate(items.length, (index) {
            final item = items[index];
            return AnimatedOpacity(
              opacity: isExpanded ? 1 : 0,
              duration: Duration(milliseconds: 180 + (index * 30)),
              child: AnimatedSlide(
                duration: Duration(milliseconds: 200 + (index * 40)),
                curve: Curves.easeOutCubic,
                offset: isExpanded ? Offset.zero : const Offset(0, 0.4),
                child: Padding(
                  padding: EdgeInsets.only(bottom: AppSizes.h10),
                  child: IgnorePointer(
                    ignoring: !isExpanded,
                    child: FloatingActionItem(data: item),
                  ),
                ),
              ),
            );
          }),
          MainFloatingButton(isExpanded: isExpanded, onTap: onMainTap),
        ],
      ),
    );
  }
}

class FloatingActionItem extends StatelessWidget {
  const FloatingActionItem({super.key, required this.data});

  final FloatingActionItemData data;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: data.backgroundColor,
      borderRadius: BorderRadius.circular(AppSizes.r80),
      child: InkWell(
        onTap: data.onTap,
        borderRadius: BorderRadius.circular(AppSizes.r80),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.w12,
            vertical: AppSizes.h10,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(data.icon, color: AppColors.whiteText, size: AppSizes.sp18),
              SizedBox(width: AppSizes.w8),
              Text(data.label, style: AppStyles.white14500.copyWith()),
            ],
          ),
        ),
      ),
    );
  }
}

class FloatingActionItemData {
  const FloatingActionItemData({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onTap;
}
