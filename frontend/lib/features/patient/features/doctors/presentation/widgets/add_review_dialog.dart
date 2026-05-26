import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class AddReviewDialog extends StatefulWidget {
  const AddReviewDialog({super.key, required this.onRate});

  final ValueChanged<int> onRate;

  @override
  State<AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog> {
  int _selectedRating = 0;

  static const List<String> _ratingLabels = [
    'Unacceptable',
    'Weak',
    'Acceptable',
    'Good',
    'Excellent',
  ];

  @override
  Widget build(BuildContext context) {
    final ratingText = _selectedRating == 0
        ? null
        : _ratingLabels[_selectedRating - 1];

    return Dialog(
      backgroundColor: AppColors.surfaceColor,
      insetPadding: EdgeInsets.symmetric(horizontal: AppSizes.w14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r40),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.w16,
          vertical: AppSizes.h20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Leave a', style: AppStyles.black24700),
            Text('Star Rating', style: AppStyles.primary70024),
            SizedBox(height: AppSizes.h18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starIndex = index + 1;
                final isSelected = starIndex <= _selectedRating;
                return IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedRating = starIndex;
                    });
                  },
                  icon: Icon(
                    Icons.star,
                    size: AppSizes.sp48,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.medicineTabUnselectedCountBackground,
                  ),
                );
              }),
            ),
            SizedBox(
              height: AppSizes.h24,
              child: ratingText == null
                  ? const SizedBox.shrink()
                  : Text(
                      ratingText,
                      style: AppStyles.black18500.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
            SizedBox(height: AppSizes.h18),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed: _selectedRating == 0
                    ? null
                    : () {
                        Navigator.of(context).pop();
                        widget.onRate(_selectedRating);
                      },
                text: 'Rate',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
