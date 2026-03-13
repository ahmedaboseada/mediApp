import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/health_measurements/presentation/models/measurement_model.dart';
import 'package:medi/features/patient/features/health_measurements/presentation/controller/health_measurements/health_measurements_cubit.dart';
import 'package:medi/features/patient/features/health_measurements/presentation/controller/health_measurements/health_measurements_state.dart';
import 'package:medi/features/patient/features/health_measurements/presentation/widgets/health_header_card.dart';
import 'package:medi/features/patient/features/health_measurements/presentation/widgets/measurement_chart_card.dart';
import 'package:medi/features/patient/features/health_measurements/presentation/widgets/measurement_tabs.dart';

class HealthMeasurementsScreen extends StatelessWidget {
  const HealthMeasurementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HealthMeasurementsCubit>(
      create: (BuildContext context) => HealthMeasurementsCubit(),
      child: const _HealthMeasurementsView(),
    );
  }
}

class _HealthMeasurementsView extends StatelessWidget {
  const _HealthMeasurementsView();

  static const List<MeasurementMetric> _cardOrder = <MeasurementMetric>[
    MeasurementMetric.bloodPressure,
    MeasurementMetric.bloodSugar,
    MeasurementMetric.bodyWeight,
    MeasurementMetric.heartRate,
  ];

  @override
  Widget build(BuildContext context) {
    final user = HiveService.getUserData();
    final firstName = user?.firstName.trim() ?? '';
    final lastName = user?.lastName.trim() ?? '';
    final fullName = <String>[firstName, lastName]
        .where((String value) => value.isNotEmpty)
        .join(' ');
    final displayName = fullName.isNotEmpty
        ? fullName
        : (user?.email.isNotEmpty ?? false)
        ? user!.email
        : AppStrings.userAhmed;
    final profileImagePath = user?.profilePicture ?? '';

    return GestureDetector(
      onTap: () => context.read<HealthMeasurementsCubit>().closeFab(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          surfaceTintColor: AppColors.transparentColor,
          leading: IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: AppSizes.sp18,
              color: AppColors.primaryText,
            ),
          ),
          title: Text(
            AppStrings.healthMeasurements,
            style: TextStyle(
              color: AppColors.primaryText,
              fontSize: AppSizes.sp18,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: false,
        ),
    
        body: SafeArea(
          child: BlocBuilder<HealthMeasurementsCubit, HealthMeasurementsState>(
            builder: (BuildContext context, HealthMeasurementsState state) {
              return CustomScrollView(
                slivers: <Widget>[
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      AppSizes.w16,
                      AppSizes.h16,
                      AppSizes.w16,
                      AppSizes.h24,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(<Widget>[
                        HealthHeaderCard(
                          userName: displayName,
                          profileImagePath: profileImagePath,
                          measurements: state.summaryMeasurements,
                          onAddPressed: context
                              .read<HealthMeasurementsCubit>()
                              .toggleFab,
                        ),
                        SizedBox(height: AppSizes.h20),
                        MeasurementTabs(
                          selectedTab: state.selectedTab,
                          onTabSelected: context
                              .read<HealthMeasurementsCubit>()
                              .selectTab,
                        ),
                        SizedBox(height: AppSizes.h20),
                      ]),
                    ),
                  ),
                  if (state.selectedTab == HealthDashboardTab.measurements)
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: AppSizes.w16),
                      sliver: SliverList.separated(
                        itemBuilder: (BuildContext context, int index) {
                          final MeasurementMetric metric = _cardOrder[index];
                          final MeasurementChartModel chartModel =
                              state.chartData[metric]!;
                          final ChartFilterRange selectedRange =
                              state.selectedChartFilters[metric]!;

                          return MeasurementChartCard(
                            title: _titleForMetric(metric),
                            chartModel: chartModel,
                            selectedRange: selectedRange,
                            onRangeChanged: (ChartFilterRange value) {
                              context
                                  .read<HealthMeasurementsCubit>()
                                  .selectChartFilter(
                                    metric: metric,
                                    range: value,
                                  );
                            },
                            animationDelay: Duration(milliseconds: index * 80),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(height: AppSizes.h16);
                        },
                        itemCount: _cardOrder.length,
                      ),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: AppSizes.w16),
                      sliver: SliverToBoxAdapter(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.w20,
                            vertical: AppSizes.h24,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceColor,
                            borderRadius: BorderRadius.circular(AppSizes.r20),
                          ),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.health_and_safety_rounded,
                                color: AppColors.primary,
                                size: AppSizes.sp32,
                              ),
                              SizedBox(height: AppSizes.h12),
                              Text(
                                AppStrings.symptoms,
                                style: TextStyle(
                                  color: AppColors.primaryText,
                                  fontSize: AppSizes.sp16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: AppSizes.h8),
                              Text(
                                AppStrings.noSymptomsTracked,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.secondaryText,
                                  fontSize: AppSizes.sp14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  SliverToBoxAdapter(child: SizedBox(height: AppSizes.h24)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String _titleForMetric(MeasurementMetric metric) {
    switch (metric) {
      case MeasurementMetric.bloodPressure:
        return AppStrings.bloodPressure;
      case MeasurementMetric.bloodSugar:
        return AppStrings.bloodSugar;
      case MeasurementMetric.bodyWeight:
        return AppStrings.bodyWeightKg;
      case MeasurementMetric.heartRate:
        return AppStrings.heartRate;
    }
  }
}
