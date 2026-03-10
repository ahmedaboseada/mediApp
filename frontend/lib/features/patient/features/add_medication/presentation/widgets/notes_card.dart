import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class NotesCard extends StatelessWidget {
  const NotesCard({
    super.key,
    required this.notes,
  });

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
          color: const Color(0xFFFFF9E6),
          borderRadius: BorderRadius.circular(AppSizes.r16),
          border: Border.all(
            color: const Color(0xFFFFD60A).withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD60A).withOpacity(0.1),
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
                  Icons.note_alt_outlined,
                  size: 20,
                  color: const Color(0xFFFF9500),
                ),
                SizedBox(width: AppSizes.w8),
                Text(
                  'Notes',
                  style: TextStyle(
                    fontSize: AppSizes.sp16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF8B6E00),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.h12),
            Text(
              notes,
              style: TextStyle(
                fontSize: AppSizes.sp14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF5D4E00),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
