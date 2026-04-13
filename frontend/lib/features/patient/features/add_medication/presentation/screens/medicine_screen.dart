import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medicine_cubit.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medicine_state.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/floating_actions_menu.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/medicine_card.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/medicine_search_bar.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/medicine_tabs.dart';

class MedicineScreen extends StatelessWidget {
  const MedicineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MedicineView();
  }
}

class _MedicineView extends StatelessWidget {
  const _MedicineView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MedicineCubit>();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.w16,
                vertical: AppSizes.h12,
              ),
              child: Column(
                children: [
                  const MedicineSearchBar(),
                  SizedBox(height: AppSizes.h16),
                  BlocSelector<MedicineCubit, MedicineState, MedicineTab>(
                    selector: (state) => state.selectedTab,
                    builder: (context, selectedTab) {
                      return MedicineTabs(
                        selectedTab: selectedTab,
                        allCount: cubit.allCount,
                        activeCount: cubit.activeCount,
                        chronicCount: cubit.chronicCount,
                        onTabSelected: cubit.changeTab,
                      );
                    },
                  ),
                  SizedBox(height: AppSizes.h16),
                  Expanded(
                    child:
                        BlocSelector<
                          MedicineCubit,
                          MedicineState,
                          List<Medication>
                        >(
                          selector: (state) => state.medications,
                          builder: (context, medications) {
                            return ListView.separated(
                              itemCount: medications.length,
                              padding: EdgeInsets.only(bottom: AppSizes.h120),
                              separatorBuilder: (_, _) =>
                                  SizedBox(height: AppSizes.h12),
                              itemBuilder: (context, index) {
                                final medication = medications[index];
                                return MedicineCard(
                                  medication: medication,
                                  onTap: () async {
                                    await context.push(
                                      '/medicine/info',
                                      extra: medication,
                                    );
                                    cubit.loadMedications();
                                  },
                                );
                              },
                            );
                          },
                        ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: AppSizes.w16,
              bottom: AppSizes.h160,
              child: const FloatingActionsMenu(),
            ),
          ],
        ),
      ),
    );
  }
}
