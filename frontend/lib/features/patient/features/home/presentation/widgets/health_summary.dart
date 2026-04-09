import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/health_measurements/data/models/measurement_model.dart';
import 'package:medi/features/patient/features/health_measurements/data/repo/logs_repo.dart';
import 'package:medi/features/patient/features/health_measurements/presentation/controller/health_measurements/health_measurements_cubit.dart';
import 'package:medi/features/patient/features/health_measurements/presentation/controller/health_measurements/health_measurements_state.dart';
import 'package:medi/features/patient/features/home/presentation/widgets/summary_item.dart';

class HealthSummary extends StatelessWidget {
  const HealthSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HealthMeasurementsCubit>(
      create: (_) => HealthMeasurementsCubit(getIt<LogsRepo>()),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.w24),
          child: BlocBuilder<HealthMeasurementsCubit, HealthMeasurementsState>(
            builder: (BuildContext context, HealthMeasurementsState state) {
              final bloodPressure = _measurementFor(
                state.summaryMeasurements,
                MeasurementMetric.bloodPressure,
              );
              final bloodSugar = _measurementFor(
                state.summaryMeasurements,
                MeasurementMetric.bloodSugar,
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Health Summary',
                        style: AppStyles.black18500.copyWith(
                          fontSize: AppSizes.sp20,
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            context.push(AppRouter.healthMeasurements),
                        child: Text(
                          'View All',
                          style: AppStyles.primaryDark12400.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.h24),
                  Row(
                    children: [
                      Expanded(
                        child: SummaryItem(
                          title: bloodPressure?.title ?? 'Blood Pressure',
                          value: bloodPressure?.value ?? 'Not recorded',
                          status: bloodPressure?.status ?? 'No data',
                          leadingIcon: AppAssets.heartRateIcon,
                        ),
                      ),
                      SizedBox(width: AppSizes.w16),
                      Expanded(
                        child: SummaryItem(
                          title: bloodSugar?.title ?? 'Blood Sugar',
                          value: bloodSugar?.value ?? 'Not recorded',
                          status: bloodSugar?.status ?? 'No data',
                          leadingIcon: AppAssets.bloodSugarIcon,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.h16),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  MeasurementModel? _measurementFor(
    List<MeasurementModel> measurements,
    MeasurementMetric metric,
  ) {
    for (final measurement in measurements) {
      if (measurement.metric == metric) {
        return measurement;
      }
    }
    return null;
  }
}
