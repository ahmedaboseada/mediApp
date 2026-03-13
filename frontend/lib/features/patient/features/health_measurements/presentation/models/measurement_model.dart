import 'package:equatable/equatable.dart';
import 'package:flutter_svg/svg.dart';

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
  });

  final MeasurementMetric metric;
  final List<ChartPoint> primaryPoints;
  final List<ChartPoint> secondaryPoints;

  bool get hasSecondaryLine => secondaryPoints.isNotEmpty;

  @override
  List<Object?> get props => <Object?>[metric, primaryPoints, secondaryPoints];
}
