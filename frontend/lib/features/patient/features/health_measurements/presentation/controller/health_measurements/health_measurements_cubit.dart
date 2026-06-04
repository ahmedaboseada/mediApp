import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dartz/dartz.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/data/local/health_logs_local_data_source.dart';
import 'package:medi/features/patient/features/health_measurements/data/models/measurement_model.dart';
import 'package:medi/features/patient/features/health_measurements/data/models/symptom.dart';
import 'package:medi/features/patient/features/health_measurements/data/repo/logs_repo.dart';
import 'package:medi/features/patient/features/health_measurements/presentation/controller/health_measurements/health_measurements_state.dart';

class HealthMeasurementsCubit extends Cubit<HealthMeasurementsState> {
  HealthMeasurementsCubit(
    this._logsRepo, {
    HealthLogsLocalDataSource? localDataSource,
  }) : _localDataSource = localDataSource ?? HealthLogsLocalDataSource(),
       super(
        HealthMeasurementsState(
          selectedTab: HealthDashboardTab.measurements,
          selectedChartFilters: const <MeasurementMetric, ChartFilterRange>{
            MeasurementMetric.bloodPressure: ChartFilterRange.days7,
            MeasurementMetric.bloodSugar: ChartFilterRange.days7,
            MeasurementMetric.bodyWeight: ChartFilterRange.days7,
            MeasurementMetric.heartRate: ChartFilterRange.days7,
          },
          chartData: <MeasurementMetric, MeasurementChartModel>{
            MeasurementMetric.bloodPressure: _emptyChartModel(
              MeasurementMetric.bloodPressure,
            ),
            MeasurementMetric.bloodSugar: _emptyChartModel(
              MeasurementMetric.bloodSugar,
            ),
            MeasurementMetric.bodyWeight: _emptyChartModel(
              MeasurementMetric.bodyWeight,
            ),
            MeasurementMetric.heartRate: _emptyChartModel(
              MeasurementMetric.heartRate,
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
          symptoms: const <SymptomModel>[],
          isFabOpen: false,
        ),
      ) {
    loadMeasurements();
    loadSymptoms();
  }

  final LogsRepo _logsRepo;
  final HealthLogsLocalDataSource _localDataSource;
  Map<MeasurementMetric, List<Map<String, dynamic>>> _metricDataCache =
      const <MeasurementMetric, List<Map<String, dynamic>>>{};

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
          ..[metric] =
              _buildChartModelFromApi(
                metric: metric,
                range: range,
                rows:
                    _metricDataCache[metric] ?? const <Map<String, dynamic>>[],
              ) ??
              _emptyChartModel(metric);

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

  Future<void> loadMeasurements() async {
    try {
      final isCaregiver = getIt<CaregiverModeCubit>().isManagingPatient;
      
      if (!isCaregiver) {
        final cachedMetricData = await _loadCachedMetricData();
        if (isClosed) {
          return;
        }

        _applyMeasurementData(cachedMetricData);
        unawaited(_syncMeasurementsFromServer());
      } else {
        await _syncMeasurementsFromServer();
      }
    } catch (e) {
      log('Error loading cached measurements: $e');
    }
  }

  Future<void> _syncMeasurementsFromServer() async {
    final bp = await _logsRepo.getBloodPressures();
    final sugar = await _logsRepo.getBloodSugars();
    final weight = await _logsRepo.getWeights();
    final heart = await _logsRepo.getHeartRates();

    if (isClosed) {
      return;
    }

    _applyMeasurementData(
      <MeasurementMetric, List<Map<String, dynamic>>>{
        MeasurementMetric.bloodPressure: _extractMeasurementsFromResponse(bp.fold((_) => null, (response) => response)),
        MeasurementMetric.bloodSugar: _extractMeasurementsFromResponse(sugar.fold((_) => null, (response) => response)),
        MeasurementMetric.bodyWeight: _extractMeasurementsFromResponse(weight.fold((_) => null, (response) => response)),
        MeasurementMetric.heartRate: _mergeHeartRateRows(
          _extractMeasurementsFromResponse(heart.fold((_) => null, (response) => response)),
          _extractHeartRatesFromBloodPressure(
            _extractMeasurementsFromResponse(bp.fold((_) => null, (response) => response)),
          ),
        ),
      },
    );
  }

  Future<Map<MeasurementMetric, List<Map<String, dynamic>>>> _loadCachedMetricData() async {
    final bp = await _localDataSource.getMeasurementResponse('blood_pressure');
    final sugar = await _localDataSource.getMeasurementResponse('blood_sugar');
    final weight = await _localDataSource.getMeasurementResponse('weight');
    final heart = await _localDataSource.getMeasurementResponse('heart_rate');

    return <MeasurementMetric, List<Map<String, dynamic>>>{
      MeasurementMetric.bloodPressure: _extractMeasurementsFromResponse(bp),
      MeasurementMetric.bloodSugar: _extractMeasurementsFromResponse(sugar),
      MeasurementMetric.bodyWeight: _extractMeasurementsFromResponse(weight),
      MeasurementMetric.heartRate: _mergeHeartRateRows(
        _extractMeasurementsFromResponse(heart),
        _extractHeartRatesFromBloodPressure(_extractMeasurementsFromResponse(bp)),
      ),
    };
  }

  void _applyMeasurementData(
    Map<MeasurementMetric, List<Map<String, dynamic>>> metricData,
  ) {
    _metricDataCache = metricData;

    final updatedChartData = <MeasurementMetric, MeasurementChartModel>{};

    for (final metric in MeasurementMetric.values) {
      final range =
          state.selectedChartFilters[metric] ?? ChartFilterRange.days7;
      final model = _buildChartModelFromApi(
        metric: metric,
        range: range,
        rows: metricData[metric] ?? const <Map<String, dynamic>>[],
      );
      updatedChartData[metric] = model ?? _emptyChartModel(metric);
    }

    emit(
      state.copyWith(
        chartData: updatedChartData,
        summaryMeasurements: _buildSummaryMeasurements(metricData),
      ),
    );
  }

  Future<Either<ApiError, String>> addBloodPressureMeasurement({
    required int systolic,
    required int diastolic,
    int? heartRate,
  }) async {
    final result = await _logsRepo.addBloodPressure(
      type: 'blood_pressure',
      systolic: systolic,
      diastolic: diastolic,
      heartRate: heartRate,
    );
    if (result.isRight()) {
      await loadMeasurements();
    }
    return result;
  }

  Future<Either<ApiError, String>> addBloodSugarMeasurement({
    required int value,
  }) async {
    final result = await _logsRepo.addBloodSugar(
      type: 'blood_sugar',
      value: value,
    );
    if (result.isRight()) {
      await loadMeasurements();
    }
    return result;
  }

  Future<Either<ApiError, String>> addWeightMeasurement({
    required double value,
  }) async {
    final result = await _logsRepo.addWeight(type: 'weight', value: value);
    if (result.isRight()) {
      await loadMeasurements();
    }
    return result;
  }

  List<Map<String, dynamic>> _extractMeasurementsFromResponse(dynamic response) {
    final map = _asStringKeyedMap(response);
    final rows = map?['measurements'];
    if (rows is List) {
      return _sortMeasurementsByDateDesc(
        rows.whereType<Map>().map((e) => e.cast<String, dynamic>()).toList(),
      );
    }
    return const <Map<String, dynamic>>[];
  }

  List<Map<String, dynamic>> _extractHeartRatesFromBloodPressure(
    List<Map<String, dynamic>> bloodPressureRows,
  ) {
    return bloodPressureRows
        .where((row) => row['heartRate'] != null)
        .map(
          (row) => <String, dynamic>{
            'date': row['date'],
            'value': row['heartRate'],
          },
        )
        .toList();
  }

  List<Map<String, dynamic>> _mergeHeartRateRows(
    List<Map<String, dynamic>> standaloneRows,
    List<Map<String, dynamic>> bloodPressureRows,
  ) {
    final combined = <Map<String, dynamic>>[
      ...standaloneRows,
      ...bloodPressureRows,
    ];
    return _sortMeasurementsByDateDesc(combined);
  }

  List<MeasurementModel> _buildSummaryMeasurements(
    Map<MeasurementMetric, List<Map<String, dynamic>>> metricData,
  ) {
    return <MeasurementModel>[
      _buildSummaryModel(MeasurementMetric.bloodPressure, metricData),
      _buildSummaryModel(MeasurementMetric.bloodSugar, metricData),
      _buildSummaryModel(MeasurementMetric.heartRate, metricData),
      _buildSummaryModel(MeasurementMetric.bodyWeight, metricData),
    ];
  }

  MeasurementModel _buildSummaryModel(
    MeasurementMetric metric,
    Map<MeasurementMetric, List<Map<String, dynamic>>> metricData,
  ) {
    final rows = metricData[metric] ?? const <Map<String, dynamic>>[];
    final todayRows = _rowsForToday(rows);
    final latestToday = todayRows.isNotEmpty
        ? todayRows.first
        : const <String, dynamic>{};

    String valueText;
    switch (metric) {
      case MeasurementMetric.bloodPressure:
        final systolic = (latestToday['systolic'] as num?)?.toInt();
        final diastolic = (latestToday['diastolic'] as num?)?.toInt();
        valueText = (systolic != null && diastolic != null)
            ? '$systolic/$diastolic'
            : 'Not recorded';
        break;
      case MeasurementMetric.bloodSugar:
        final value = (latestToday['value'] as num?)?.toInt();
        valueText = value != null ? '$value mg/dL' : 'Not recorded';
        break;
      case MeasurementMetric.heartRate:
        final value = (latestToday['value'] as num?)?.toInt();
        valueText = value != null ? '$value bpm' : 'Not recorded';
        break;
      case MeasurementMetric.bodyWeight:
        final value = (latestToday['value'] as num?)?.toDouble();
        valueText = value != null ? '$value kg' : 'Not recorded';
        break;
    }

    return MeasurementModel(
      metric: metric,
      title: _metricTitle(metric),
      status: AppStrings.normal,
      value: valueText,
      icon: SvgPicture.asset(
        _metricAsset(metric),
        width: AppSizes.w34,
        height: AppSizes.h34,
      ),
    );
  }

  List<Map<String, dynamic>> _rowsForToday(List<Map<String, dynamic>> rows) {
    final today = DateTime.now();
    final List<Map<String, dynamic>> todayRows = <Map<String, dynamic>>[];

    for (final row in rows) {
      final parsed = _tryParseDate(row['date']);
      if (parsed == null) {
        continue;
      }

      final localDate = parsed.toLocal();
      if (localDate.year == today.year &&
          localDate.month == today.month &&
          localDate.day == today.day) {
        todayRows.add(row);
      }
    }

    return todayRows;
  }

  String _metricTitle(MeasurementMetric metric) {
    switch (metric) {
      case MeasurementMetric.bloodPressure:
        return AppStrings.bloodPressure;
      case MeasurementMetric.bloodSugar:
        return AppStrings.bloodSugar;
      case MeasurementMetric.heartRate:
        return AppStrings.heartRate;
      case MeasurementMetric.bodyWeight:
        return AppStrings.weight;
    }
  }

  String _metricAsset(MeasurementMetric metric) {
    switch (metric) {
      case MeasurementMetric.bloodPressure:
        return AppAssets.bloodPressure;
      case MeasurementMetric.bloodSugar:
        return AppAssets.bloodSugarIcon;
      case MeasurementMetric.heartRate:
        return AppAssets.heartRateIcon;
      case MeasurementMetric.bodyWeight:
        return AppAssets.weightScaleIcon;
    }
  }

  MeasurementChartModel? _buildChartModelFromApi({
    required MeasurementMetric metric,
    required ChartFilterRange range,
    required List<Map<String, dynamic>> rows,
  }) {
    if (rows.isEmpty) return null;

    final maxPoints = switch (range) {
      ChartFilterRange.days7 => 7,
      ChartFilterRange.days30 => 30,
      ChartFilterRange.days90 => 90,
    };

    final selected = _selectRowsByUniqueDay(rows, maxPoints).reversed.toList();
    final xLabels = selected
        .map((e) => _buildXAxisLabel(e['date'], range))
        .toList();

    if (metric == MeasurementMetric.bloodPressure) {
      final systolic = selected
          .map((e) => (e['systolic'] as num?)?.toDouble())
          .whereType<double>()
          .toList();
      final diastolic = selected
          .map((e) => (e['diastolic'] as num?)?.toDouble())
          .whereType<double>()
          .toList();
      if (systolic.isEmpty || diastolic.isEmpty) return null;

      return MeasurementChartModel(
        metric: metric,
        primaryPoints: List<ChartPoint>.generate(
          systolic.length,
          (i) => ChartPoint(x: i.toDouble(), y: systolic[i]),
        ),
        secondaryPoints: List<ChartPoint>.generate(
          diastolic.length,
          (i) => ChartPoint(x: i.toDouble(), y: diastolic[i]),
        ),
        xLabels: xLabels,
      );
    }

    final values = selected
        .map((e) => (e['value'] as num?)?.toDouble())
        .whereType<double>()
        .toList();
    if (values.isEmpty) return null;

    return MeasurementChartModel(
      metric: metric,
      primaryPoints: List<ChartPoint>.generate(
        values.length,
        (i) => ChartPoint(x: i.toDouble(), y: values[i]),
      ),
      xLabels: xLabels,
    );
  }

  List<Map<String, dynamic>> _selectRowsByUniqueDay(
    List<Map<String, dynamic>> rows,
    int maxPoints,
  ) {
    final byDay = <String, Map<String, dynamic>>{};
    final noDate = <Map<String, dynamic>>[];

    for (final row in rows) {
      final key = _dayKey(row['date']);
      if (key == null) {
        noDate.add(row);
        continue;
      }
      byDay.putIfAbsent(key, () => row);
      if (byDay.length >= maxPoints) {
        break;
      }
    }

    final merged = <Map<String, dynamic>>[...byDay.values, ...noDate];

    return merged.take(maxPoints).toList();
  }

  List<Map<String, dynamic>> _sortMeasurementsByDateDesc(
    List<Map<String, dynamic>> rows,
  ) {
    final sorted = List<Map<String, dynamic>>.from(rows);
    sorted.sort((left, right) {
      final leftDate =
          _tryParseDate(left['date']) ?? DateTime.fromMillisecondsSinceEpoch(0);
      final rightDate =
          _tryParseDate(right['date']) ??
          DateTime.fromMillisecondsSinceEpoch(0);
      return rightDate.compareTo(leftDate);
    });
    return sorted;
  }

  String? _dayKey(dynamic rawDate) {
    final parsed = _tryParseDate(rawDate);
    if (parsed == null) return null;
    final y = parsed.year.toString().padLeft(4, '0');
    final m = parsed.month.toString().padLeft(2, '0');
    final d = parsed.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String _buildXAxisLabel(dynamic rawDate, ChartFilterRange range) {
    final parsed = _tryParseDate(rawDate);
    if (parsed == null) return '';

    if (range == ChartFilterRange.days7) {
      return _weekdayShort(parsed.weekday);
    }

    final day = parsed.day.toString().padLeft(2, '0');
    final month = parsed.month.toString().padLeft(2, '0');
    return '$day/$month';
  }

  DateTime? _tryParseDate(dynamic rawDate) {
    if (rawDate is! String || rawDate.trim().isEmpty) {
      return null;
    }
    return DateTime.tryParse(rawDate);
  }

  String _weekdayShort(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }

  Future<void> loadSymptoms() async {
    try {
      final isCaregiver = getIt<CaregiverModeCubit>().isManagingPatient;
      
      if (!isCaregiver) {
        final cached = await _localDataSource.getSymptomResponse();
        if (cached != null && !isClosed) {
          _applySymptomsFromResponse(cached);
        }

        unawaited(_syncSymptomsFromServer(hadCachedData: cached != null));
      } else {
        await _syncSymptomsFromServer(hadCachedData: false);
      }
    } catch (e) {
      log('Error loading cached symptoms: $e');
    }
  }

  Future<void> _syncSymptomsFromServer({required bool hadCachedData}) async {
    final result = await _logsRepo.getSymptomLogs();

    if (isClosed) {
      return;
    }

    result.fold((error) {
      if (!hadCachedData) {
        log('Error loading symptoms: ${error.message}');
      }
    }, _applySymptomsFromResponse);
  }

  void _applySymptomsFromResponse(dynamic response) {
    final map = _asStringKeyedMap(response);
    final rows = map?['symptoms'];
    if (rows is List) {
      final symptoms = rows
          .whereType<Map>()
          .map((e) => e.cast<String, dynamic>())
          .map((json) => SymptomModel.fromJson(json))
          .toList();
      if (isClosed) {
        return;
      }
      emit(state.copyWith(symptoms: symptoms));
      return;
    }

    log('Unexpected response format for symptoms: $response');
  }

  Map<String, dynamic>? _asStringKeyedMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.cast<String, dynamic>();
    }
    return null;
  }

  static MeasurementChartModel _emptyChartModel(MeasurementMetric metric) {
    return MeasurementChartModel(
      metric: metric,
      primaryPoints: const <ChartPoint>[],
      secondaryPoints: const <ChartPoint>[],
    );
  }
}
