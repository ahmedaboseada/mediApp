import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class MedicineHeaderCard extends StatelessWidget {
  const MedicineHeaderCard({
    super.key,
    required this.medicineName,
    required this.subtitle,
    required this.isTaken,
    required this.onTakenChanged,
    required this.imagePath,
  });

  final String medicineName;
  final String subtitle;
  final bool isTaken;
  final ValueChanged<bool> onTakenChanged;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(AppSizes.w20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2178F3), Color(0xFF1A5FCC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppSizes.r16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2178F3).withOpacity(0.25),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // Medicine Icon
            Image.asset(
              imagePath,
              width: 64,
              height: 64,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.medication_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
            SizedBox(width: AppSizes.w16),
            // Medicine Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicineName,
                    style: TextStyle(
                      fontSize: AppSizes.sp20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: AppSizes.h4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: AppSizes.sp14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  SizedBox(height: AppSizes.h12),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomToggleSwitch(
                  value: isTaken,
                  onChanged: onTakenChanged,
                  width: 50,
                  height: 26,
                ),
                SizedBox(height: AppSizes.h4),
                Text(
                  isTaken ? 'Taken' : 'Not Taken',
                  style: TextStyle(
                    fontSize: AppSizes.sp12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.95),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
