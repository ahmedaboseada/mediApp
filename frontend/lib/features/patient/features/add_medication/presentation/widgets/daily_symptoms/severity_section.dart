import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class SeveritySection extends StatelessWidget {
  const SeveritySection({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Severity',
          style: AppStyles.black18500.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: AppSizes.h8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            thumbColor: AppColors.primary,
            activeTrackColor: AppColors.secondary,
            inactiveTrackColor: AppColors.secondary,
            trackHeight: AppSizes.h34,
            overlayShape: SliderComponentShape.noOverlay,
          ),
          child: Slider(value: value, onChanged: onChanged),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.w4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('none', style: AppStyles.tertiary14500),
              Text('moderate', style: AppStyles.tertiary14500),
              Text('severe', style: AppStyles.tertiary14500),
            ],
          ),
        ),
      ],
    );
  }
}
