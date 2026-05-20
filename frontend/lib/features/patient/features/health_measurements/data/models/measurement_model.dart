import 'package:equatable/equatable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medi/core/constants/app_assets.dart';

enum MeasurementMetric { bloodPressure, bloodSugar, bodyWeight, heartRate }

class MeasurementModel extends Equatable {
  const MeasurementModel({
    required this.metric,
    required this.title,
    required this.status,
    required this.value,
    required this.icon,
  });

  final MeasurementMetric metric;
  final String title;
  final String status;
  final String value;
  final SvgPicture icon;

  factory MeasurementModel.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String?;
    final valueNum = json['value'];

    MeasurementMetric metric = MeasurementMetric.bodyWeight;
    String title = '';
    String valueStr = '';
    String assetPath = AppAssets.weightScaleIcon;

    switch (type) {
      case 'blood_pressure':
        metric = MeasurementMetric.bloodPressure;
        title = 'Blood Pressure';
        assetPath = AppAssets.bloodPressureIcon;
        final sys = json['systolic'] ?? 0;
        final dia = json['diastolic'] ?? 0;
        valueStr = '$sys/$dia';
        break;
      case 'blood_sugar':
        metric = MeasurementMetric.bloodSugar;
        title = 'Blood Sugar';
        assetPath = AppAssets.bloodSugarIcon;
        valueStr = '${valueNum ?? 0} mg/dL';
        break;
      case 'heart_rate':
        metric = MeasurementMetric.heartRate;
        title = 'Heart Rate';
        assetPath = AppAssets.heartRateIcon;
        valueStr = '${valueNum ?? 0} bpm';
        break;
      case 'weight':
      default:
        metric = MeasurementMetric.bodyWeight;
        title = 'Weight';
        assetPath = AppAssets.weightScaleIcon;
        valueStr = '${valueNum ?? 0} kg';
        break;
    }

    return MeasurementModel(
      metric: metric,
      title: title,
      status:
          json['status'] ?? 'Normal', // Adjust if backend provides status later
      value: valueStr,
      icon: SvgPicture.asset(assetPath, width: 24, height: 24),
    );
  }

  @override
  List<Object?> get props => <Object?>[metric, title, status, value, icon];
}

class ChartPoint extends Equatable {
  const ChartPoint({required this.x, required this.y});

  final double x;
  final double y;

  @override
  List<Object?> get props => <Object?>[x, y];
}

class MeasurementChartModel extends Equatable {
  const MeasurementChartModel({
    required this.metric,
    required this.primaryPoints,
    this.secondaryPoints = const <ChartPoint>[],
    this.xLabels = const <String>[],
  });

  final MeasurementMetric metric;
  final List<ChartPoint> primaryPoints;
  final List<ChartPoint> secondaryPoints;
  final List<String> xLabels;

  bool get hasSecondaryLine => secondaryPoints.isNotEmpty;

  @override
  List<Object?> get props => <Object?>[
    metric,
    primaryPoints,
    secondaryPoints,
    xLabels,
  ];
}
