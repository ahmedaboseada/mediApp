import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class SideEffectsCard extends StatelessWidget {
  const SideEffectsCard({super.key, required this.sideEffects});

  final List<String> sideEffects;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 25 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(AppSizes.w20),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(AppSizes.r16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 24,
                ),
                SizedBox(width: AppSizes.w8),
                Text(
                  'Potential Side Effects',
                  style: TextStyle(
                    fontSize: AppSizes.sp16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.h16),
            ...List.generate(sideEffects.length, (index) {
              return TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 500 + (index * 150)),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: AppSizes.h8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: AppSizes.h6),
                            child: Container(
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF3B30),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          SizedBox(width: AppSizes.w12),
                          Expanded(
                            child: Text(
                              sideEffects[index],
                              style: TextStyle(
                                fontSize: AppSizes.sp14,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFFFF3B30),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
