import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class MedicationActivity extends StatelessWidget {
  const MedicationActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Medication Activity",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          activityItem(
            isTaken: true,
            date: "Feb 17, 2026",
            time: "08:30 AM",
            note: "Blood sugar was 145 mg/dL before injection",
          ),
          activityItem(
            isTaken: true,
            date: "Feb 16, 2026",
            time: "07:00 PM",
          ),
          activityItem(
            isTaken: true,
            date: "Feb 16, 2026",
            time: "08:30 AM",
            note: "Feeling good today",
          ),
          activityItem(
            isTaken: false,
            date: "Feb 15, 2026",
            time: "08:30 AM",
            note: "Forgot to take - was traveling",
          ),
        ],
      ),
    );
  }

  Widget activityItem({
    required bool isTaken,
    required String date,
    required String time,
    String? note,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// timeline
          Column(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: isTaken ? Colors.green : Colors.red,
                child: Icon(
                  isTaken ? Icons.check : Icons.close,
                  color: Colors.white,
                  size: 14,
                ),
              ),
              Expanded(
                child: Container(
                  width: 1,
                 // height: AppSizes.h60,
                  color: AppColors.dividerColor,
                ),
              ),
            ],
          ),

        const SizedBox(width: 12),

        /// المحتوى
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// date + status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(date,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold)),
                      Text(time,
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isTaken ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isTaken ? "Taken" : "Missed",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),

              if (note != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(note),
                ),
              ],

              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
      ),
    );
  }
}