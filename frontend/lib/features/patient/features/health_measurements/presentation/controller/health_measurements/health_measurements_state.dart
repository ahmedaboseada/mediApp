import 'package:equatable/equatable.dart';
import 'package:medi/features/patient/features/health_measurements/data/models/measurement_model.dart';
import 'package:medi/features/patient/features/health_measurements/data/models/symptom.dart';

enum HealthDashboardTab { measurements, symptoms }

enum ChartFilterRange { days7, days30, days90 }

class HealthMeasurementsState extends Equatable {
  const HealthMeasurementsState({
    required this.selectedTab,
    required this.selectedChartFilters,
    required this.chartData,
    required this.summaryMeasurements,
    required this.symptoms,
    required this.isFabOpen,
  });

  final HealthDashboardTab selectedTab;
  final Map<MeasurementMetric, ChartFilterRange> selectedChartFilters;
  final Map<MeasurementMetric, MeasurementChartModel> chartData;
  final List<MeasurementModel> summaryMeasurements;
  final List<SymptomModel> symptoms;
  final bool isFabOpen;

  HealthMeasurementsState copyWith({
    HealthDashboardTab? selectedTab,
    Map<MeasurementMetric, ChartFilterRange>? selectedChartFilters,
    Map<MeasurementMetric, MeasurementChartModel>? chartData,
    List<MeasurementModel>? summaryMeasurements,
    List<SymptomModel>? symptoms,
    bool? isFabOpen,
  }) {
    return HealthMeasurementsState(
      selectedTab: selectedTab ?? this.selectedTab,
      selectedChartFilters: selectedChartFilters ?? this.selectedChartFilters,
      chartData: chartData ?? this.chartData,
      summaryMeasurements: summaryMeasurements ?? this.summaryMeasurements,
      symptoms: symptoms ?? this.symptoms,
      isFabOpen: isFabOpen ?? this.isFabOpen,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    selectedTab,
    selectedChartFilters,
    chartData,
    summaryMeasurements,
    symptoms,
    isFabOpen,
  ];
}
