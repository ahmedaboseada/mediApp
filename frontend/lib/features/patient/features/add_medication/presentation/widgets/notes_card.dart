import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medi/core/core.dart';

class NotesCard extends StatelessWidget {
  const NotesCard({super.key, required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) return const SizedBox.shrink();

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 900),
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
          color: const Color(0xFFFEF5E7),
          borderRadius: BorderRadius.circular(AppSizes.r16),
          border: Border.all(color: const Color(0xFFFBD89D)),
         
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(AppAssets.papers, width: AppSizes.w20, height: AppSizes.h20),
                SizedBox(width: AppSizes.w8),
                Text(
                  'Notes',
                  style: 
                 AppStyles.black14600.copyWith(fontSize: AppSizes.sp16),
                ),
              ],
            ),
            SizedBox(height: AppSizes.h12),
            Text(
              notes,
              style: AppStyles.black14400,
            ),
          ],
        ),
      ),
    );
  }
}
