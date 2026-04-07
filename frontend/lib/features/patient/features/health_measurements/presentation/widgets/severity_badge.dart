import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class SeverityBadge extends StatelessWidget {
  const SeverityBadge({super.key,  required this.severity});

  final String severity;

  @override
  Widget build(BuildContext context) {
    final normalized = severity.trim().toLowerCase();
    final style = _styleFor(normalized);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w16,
        vertical: AppSizes.h6,
      ),
      decoration: BoxDecoration(
        color: style.$1,
        borderRadius: BorderRadius.circular(AppSizes.r200),
      ),
      child: Text(
        style.$2,
        style:AppStyles.white12400,
      ),
    );
  }

  (Color, String) _styleFor(String severity) {
    switch (severity) {
      case 'severe':
        return (const Color(0xFFE24A51), 'Severe');
      case 'moderate':
        return (const Color(0xFFFF7A00), 'Moderate');
      case 'mild':
      case 'low':
        return (const Color(0xFF2BBF5B), 'Mild');
      case 'none':
        return (const Color(0xFF2BBF5B), 'none');
      default:
        return (const Color(0xFF8A94A6), severity.isEmpty ? 'Unknown' : severity);
    }
  }
}