import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/health_measurements/data/models/measurement_model.dart';
import 'package:medi/features/patient/features/health_measurements/presentation/controller/health_measurements/health_measurements_state.dart';

class HealthMeasurementsCubit extends Cubit<HealthMeasurementsState> {
  HealthMeasurementsCubit()
    : super(
        HealthMeasurementsState(
          selectedTab: HealthDashboardTab.measurements,
          selectedChartFilters: const <MeasurementMetric, ChartFilterRange>{
            MeasurementMetric.bloodPressure: ChartFilterRange.days7,
            MeasurementMetric.bloodSugar: ChartFilterRange.days7,
            MeasurementMetric.bodyWeight: ChartFilterRange.days7,
            MeasurementMetric.heartRate: ChartFilterRange.days7,
          },
          chartData: <MeasurementMetric, MeasurementChartModel>{
            MeasurementMetric.bloodPressure: _buildChartModel(
              metric: MeasurementMetric.bloodPressure,
              range: ChartFilterRange.days7,
            ),
            MeasurementMetric.bloodSugar: _buildChartModel(
              metric: MeasurementMetric.bloodSugar,
              range: ChartFilterRange.days7,
            ),
            MeasurementMetric.bodyWeight: _buildChartModel(
              metric: MeasurementMetric.bodyWeight,
              range: ChartFilterRange.days7,
            ),
            MeasurementMetric.heartRate: _buildChartModel(
              metric: MeasurementMetric.heartRate,
              range: ChartFilterRange.days7,
            ),
          },
          summaryMeasurements: <MeasurementModel>[
            MeasurementModel(
              metric: MeasurementMetric.bloodPressure,
              title: AppStrings.bloodPressure,
              status: AppStrings.normal,
              value: AppStrings.bloodPressureValue,
              icon: SvgPicture.asset(
                AppAssets.bloodPressure,
                width: AppSizes.w34,
                height: AppSizes.h34,
              ),
            ),
            MeasurementModel(
              metric: MeasurementMetric.bloodSugar,
              title: AppStrings.bloodSugar,
              status: AppStrings.normal,
              value: AppStrings.bloodSugarValue,
              icon: SvgPicture.asset(
                AppAssets.bloodSugarIcon,
                width: AppSizes.w34,
                height: AppSizes.h34,
              ),
            ),
            MeasurementModel(
              metric: MeasurementMetric.heartRate,
              title: AppStrings.heartRate,
              status: AppStrings.normal,
              value: AppStrings.heartRateValue,
              icon: SvgPicture.asset(
                AppAssets.heartRateIcon,
                width: AppSizes.w34,
                height: AppSizes.h34,
              ),
            ),
            MeasurementModel(
              metric: MeasurementMetric.bodyWeight,
              title: AppStrings.weight,
              status: AppStrings.normal,
              value: AppStrings.weightValue,
              icon: SvgPicture.asset(
                AppAssets.weightScaleIcon,
                width: AppSizes.w34,
                height: AppSizes.h34,
              ),
            ),
          ],
          isFabOpen: false,
        ),
      );

  void selectTab(HealthDashboardTab tab) {
    emit(state.copyWith(selectedTab: tab));
  }

  void selectChartFilter({
    required MeasurementMetric metric,
    required ChartFilterRange range,
  }) {
    final Map<MeasurementMetric, ChartFilterRange> updatedFilters =
        Map<MeasurementMetric, ChartFilterRange>.from(
          state.selectedChartFilters,
        )..[metric] = range;

    final Map<MeasurementMetric, MeasurementChartModel> updatedChartData =
        Map<MeasurementMetric, MeasurementChartModel>.from(state.chartData)
          ..[metric] = _buildChartModel(metric: metric, range: range);

    emit(
      state.copyWith(
        selectedChartFilters: updatedFilters,
        chartData: updatedChartData,
      ),
    );
  }

  void toggleFab() {
    emit(state.copyWith(isFabOpen: !state.isFabOpen));
  }

  void closeFab() {
    if (!state.isFabOpen) {
      return;
    }
    emit(state.copyWith(isFabOpen: false));
  }

  static MeasurementChartModel _buildChartModel({
    required MeasurementMetric metric,
    required ChartFilterRange range,
  }) {
    final List<double> primary = _mockPrimarySeries[metric]![range]!;
    final List<double> secondary =
        _mockSecondarySeries[metric]?[range] ?? const <double>[];

    return MeasurementChartModel(
      metric: metric,
      primaryPoints: List<ChartPoint>.generate(
        primary.length,
        (int index) => ChartPoint(x: index.toDouble(), y: primary[index]),
      ),
      secondaryPoints: List<ChartPoint>.generate(
        secondary.length,
        (int index) => ChartPoint(x: index.toDouble(), y: secondary[index]),
      ),
    );
  }

  static const Map<MeasurementMetric, Map<ChartFilterRange, List<double>>>
  _mockPrimarySeries = <MeasurementMetric, Map<ChartFilterRange, List<double>>>{
    MeasurementMetric.bloodPressure: <ChartFilterRange, List<double>>{
      ChartFilterRange.days7: <double>[118, 120, 116, 122, 124, 121, 119],
      ChartFilterRange.days30: <double>[120, 122, 121, 119, 123, 124, 122],
      ChartFilterRange.days90: <double>[122, 121, 120, 124, 123, 122, 121],
    },
    MeasurementMetric.bloodSugar: <ChartFilterRange, List<double>>{
      ChartFilterRange.days7: <double>[92, 96, 94, 99, 95, 93, 97],
      ChartFilterRange.days30: <double>[95, 94, 96, 98, 97, 95, 96],
      ChartFilterRange.days90: <double>[98, 97, 95, 94, 96, 97, 95],
    },
    MeasurementMetric.bodyWeight: <ChartFilterRange, List<double>>{
      ChartFilterRange.days7: <double>[
        68.5,
        68.4,
        68.3,
        68.1,
        68.0,
        67.9,
        68.0,
      ],
      ChartFilterRange.days30: <double>[
        68.8,
        68.7,
        68.5,
        68.4,
        68.3,
        68.2,
        68.1,
      ],
      ChartFilterRange.days90: <double>[
        69.2,
        69.0,
        68.9,
        68.7,
        68.6,
        68.5,
        68.3,
      ],
    },
    MeasurementMetric.heartRate: <ChartFilterRange, List<double>>{
      ChartFilterRange.days7: <double>[71, 73, 72, 70, 74, 72, 71],
      ChartFilterRange.days30: <double>[72, 71, 73, 74, 72, 71, 72],
      ChartFilterRange.days90: <double>[74, 73, 72, 71, 72, 73, 72],
    },
  };

  static const Map<MeasurementMetric, Map<ChartFilterRange, List<double>>>
  _mockSecondarySeries =
      <MeasurementMetric, Map<ChartFilterRange, List<double>>>{
        MeasurementMetric.bloodPressure: <ChartFilterRange, List<double>>{
          ChartFilterRange.days7: <double>[78, 80, 79, 82, 81, 80, 79],
          ChartFilterRange.days30: <double>[80, 79, 81, 82, 80, 79, 80],
          ChartFilterRange.days90: <double>[82, 81, 80, 79, 80, 81, 80],
        },
      };
}
