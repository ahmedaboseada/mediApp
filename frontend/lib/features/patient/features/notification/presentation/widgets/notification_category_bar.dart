import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/notification/presentation/models/notification_item.dart';

class NotificationCategoryBar extends StatelessWidget {
  const NotificationCategoryBar({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final NotificationCategory selectedCategory;
  final ValueChanged<NotificationCategory> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: NotificationCategory.values
            .map(
              (category) => Padding(
                padding: EdgeInsets.only(right: AppSizes.w8),
                child: _CategoryChip(
                  label: category.label,
                  selected: selectedCategory == category,
                  onTap: () => onCategorySelected(category),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : const Color(0xFFDCE6F5),
      borderRadius: BorderRadius.circular(AppSizes.r40),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.r40),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.w14,
            vertical: AppSizes.h8,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.whiteText : AppColors.primaryText,
              fontSize: AppSizes.sp12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}