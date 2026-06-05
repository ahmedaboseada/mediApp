import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/home/presentation/controller/alerts/low_stock_alerts_cubit.dart';
import 'package:medi/features/patient/features/home/presentation/controller/alerts/low_stock_alerts_state.dart';

import 'package:medi/features/patient/features/add_medication/data/repo/medicine_repo.dart';

class LowStockAlerts extends StatefulWidget {
  const LowStockAlerts({super.key});

  @override
  State<LowStockAlerts> createState() => _LowStockAlertsState();
}

class _LowStockAlertsState extends State<LowStockAlerts> {
  late final LowStockAlertsCubit _alertsCubit;

  @override
  void initState() {
    super.initState();
    _alertsCubit = LowStockAlertsCubit(getIt<MedicineRepo>())
      ..checkLowStockAlerts();
  }

  @override
  void dispose() {
    _alertsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LowStockAlertsCubit>.value(
      value: _alertsCubit,
      child: BlocBuilder<LowStockAlertsCubit, LowStockAlertsState>(
        builder: (context, state) {
        if (state is LowStockAlertsSuccess && state.lowStockMedications.isNotEmpty) {
          return Card(
            child: Padding(
              padding: EdgeInsets.all(AppSizes.w24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alerts',
                   style: AppStyles.black24700.copyWith(
                        fontSize: AppSizes.sp20,
                      ),
                  ),
                  SizedBox(height: AppSizes.h18),
                  ...state.lowStockMedications.map((medication) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: AppSizes.h12),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.w16,
                          vertical: AppSizes.h12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppSizes.r12),
                          border: Border.all(
                            color: AppColors.warning,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                           SvgPicture.asset(
                              AppAssets.medicineBox,
                              color: AppColors.warning,
                              width: AppSizes.w20,
                              height: AppSizes.h20,
                            ),
                            SizedBox(width: AppSizes.w12),
                            Expanded(
                              child: Text(
                                '${medication.name} - Low stock',
                                style: AppStyles.black14400.copyWith(
                                  color: AppColors.warning,
                                ),
                              ),
                            ),
                            SizedBox(width: AppSizes.w12),
                            ElevatedButton(
                              onPressed: () {
                                context.push(
                                  AppRouter.medicineInfoScreen,
                                  extra: medication,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.warning,
                                foregroundColor: AppColors.surfaceColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppSizes.r24),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSizes.w16,
                                  vertical: AppSizes.h8,
                                ),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'View',
                                style: AppStyles.white14500.copyWith(
                                  fontSize: AppSizes.sp12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    ),
   );
  }
}
