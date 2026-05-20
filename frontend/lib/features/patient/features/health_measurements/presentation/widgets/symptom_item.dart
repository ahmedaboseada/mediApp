import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/health_measurements/data/models/symptom.dart';
import 'package:medi/features/patient/features/health_measurements/presentation/widgets/severity_badge.dart';

class SymptomItem extends StatelessWidget {
  const SymptomItem({super.key, required this.data});

  final SymptomModel data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.h16),
      padding: EdgeInsets.all(AppSizes.w16),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF4FF),
        borderRadius: BorderRadius.circular(AppSizes.r24),
        border: Border.all(color: const Color(0xFFD1E4FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.allSymptoms.isNotEmpty
                          ? data.allSymptoms.first
                          : 'None',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: const Color(0xFF1D2738),
                        fontSize: AppSizes.sp20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: AppSizes.h6),
                    Text(
                      _formatDate(data.date),
                      style: TextStyle(
                        color: const Color(0xFF7C8798),
                        fontSize: AppSizes.sp16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSizes.w12),
              SeverityBadge(severity: data.severity),
            ],
          ),
          SizedBox(height: AppSizes.h14),
          Text(
            data.notes.isNotEmpty
                ? data.notes
                : _symptomsFallback(data.allSymptoms),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF5E6879),
              fontSize: AppSizes.sp16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? value) {
    if (value == null) {
      return '';
    }

    final local = value.toLocal();
    final y = local.year.toString().padLeft(4, '0');
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String _symptomsFallback(List<String> symptoms) {
    if (symptoms.isEmpty) {
      return 'No notes';
    }
    return symptoms.join(', ');
  }
}
