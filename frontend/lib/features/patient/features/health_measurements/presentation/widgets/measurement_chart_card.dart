import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/health_measurements/presentation/models/measurement_model.dart';
import 'package:medi/features/patient/features/health_measurements/presentation/state/health_measurements_state.dart';
import 'package:medi/features/patient/features/health_measurements/presentation/widgets/chart_filter_tabs.dart';

class MeasurementChartCard extends StatelessWidget {
  const MeasurementChartCard({
    super.key,
    required this.title,
    required this.chartModel,
    required this.selectedRange,
    required this.onRangeChanged,
    this.animationDelay = Duration.zero,
  });

  final String title;
  final MeasurementChartModel chartModel;
  final ChartFilterRange selectedRange;
  final ValueChanged<ChartFilterRange> onRangeChanged;
  final Duration animationDelay;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: AppSizes.p0, end: AppSizes.p1),
      duration: Duration(milliseconds: 420 + animationDelay.inMilliseconds),
      curve: Curves.easeOutCubic,
      builder: (BuildContext context, double value, Widget? child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              AppSizes.p0,
              (AppSizes.h24 - (AppSizes.h24 * value)),
            ),
            child: child,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(AppSizes.w16),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(AppSizes.r20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: AppSizes.sp16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                ChartFilterTabs(
                  selectedRange: selectedRange,
                  onRangeChanged: onRangeChanged,
                ),
              ],
            ),
            SizedBox(height: AppSizes.h16),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: AppSizes.p0, end: AppSizes.p1),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
              builder: (BuildContext context, double opacity, Widget? child) {
                return Opacity(opacity: opacity, child: child);
              },
              child: Container(
                color: Color(0xffEEF4FF) ,
                height: AppSizes.h200,
                child: LineChart(
                  _buildChartData(chartModel),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                ),
              ),
            ),
            if (chartModel.hasSecondaryLine) ...<Widget>[
              SizedBox(height: AppSizes.h10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _LegendDot(
                    color: AppColors.error,
                    label: AppStrings.systolic,
                  ),
                  SizedBox(width: AppSizes.w16),
                  _LegendDot(
                    color: AppColors.primary,
                    label: AppStrings.diastolic,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  LineChartData _buildChartData(MeasurementChartModel model) {
    return LineChartData(
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 140,
      lineTouchData: const LineTouchData(enabled: true),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 35,
        getDrawingHorizontalLine: (double value) {
          return FlLine(color: AppColors.borderColor, strokeWidth: AppSizes.p1);
        },
      ),
      borderData: FlBorderData(show: true, border: Border.all(color: AppColors.borderColor)),
      titlesData: FlTitlesData(
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: AppSizes.w24,
            interval: 35,
            getTitlesWidget: (double value, TitleMeta meta) {
              return Text(
                value.toInt().toString(),
                style: TextStyle(
                  color: AppColors.tertiaryText,
                  fontSize: AppSizes.sp10,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: AppSizes.h24,
            interval: AppSizes.p1,
            getTitlesWidget: (double value, TitleMeta meta) {
              const List<String> monthLabels = <String>[
                AppStrings.monthJan,
                AppStrings.monthFeb,
                AppStrings.monthMar,
                AppStrings.monthApr,
                AppStrings.monthMay,
                AppStrings.monthJun,
                AppStrings.monthJul,
                AppStrings.monthAug,
                AppStrings.monthSep,
                AppStrings.monthOct,
                AppStrings.monthNov,
                AppStrings.monthDec,

              ];

              final int index = value.toInt();
              if (index < 0 || index >= monthLabels.length) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: EdgeInsets.only(top: AppSizes.h8),
                child: Text(
                  monthLabels[index],
                  style: TextStyle(
                    color: AppColors.tertiaryText,
                    fontSize: AppSizes.sp10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      lineBarsData: <LineChartBarData>[
        _lineData(
          points: model.primaryPoints,
          color: model.metric == MeasurementMetric.bloodPressure
              ? AppColors.error
              : AppColors.primaryDark,
          showFill: model.metric != MeasurementMetric.bloodPressure,
        ),
        if (model.hasSecondaryLine)
          _lineData(points: model.secondaryPoints, color: AppColors.primary),
      ],
    );
  }

  LineChartBarData _lineData({
    required List<ChartPoint> points,
    required Color color,
    bool showFill = false,
  }) {
    return LineChartBarData(
      isCurved: false,
      color: color,
      barWidth: AppSizes.w2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter:
            (FlSpot spot, double percent, LineChartBarData barData, int index) {
              return FlDotCirclePainter(
                radius: AppSizes.r4,
                color: color,
                strokeColor: AppColors.surfaceColor,
                strokeWidth: AppSizes.p1,
              );
            },
      ),
      belowBarData: BarAreaData(
        show: showFill,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            color.withValues(alpha: 0.18),
            color.withValues(alpha: 0.0),
          ],
        ),
      ),
      spots: points
          .map((ChartPoint point) => FlSpot(point.x, point.y))
          .toList(growable: false),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: AppSizes.w8,
          height: AppSizes.h8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppSizes.r200),
          ),
        ),
        SizedBox(width: AppSizes.w4),
        Text(
          label,
          style: TextStyle(
            color: AppColors.secondaryText,
            fontSize: AppSizes.sp12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
