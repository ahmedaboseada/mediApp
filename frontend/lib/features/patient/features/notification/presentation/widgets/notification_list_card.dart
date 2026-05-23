import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/notification/presentation/models/notification_item.dart';

class NotificationSectionHeader extends StatelessWidget {
  const NotificationSectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.tertiaryText,
        fontSize: AppSizes.sp12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }
}

class NotificationListCard extends StatelessWidget {
  const NotificationListCard({super.key, required this.item});

  final NotificationInboxItem item;

  @override
  Widget build(BuildContext context) {
    final iconData = _iconForCategory(item.category);

    return Container(
      padding: EdgeInsets.all(AppSizes.w14),
      decoration: BoxDecoration(
        color: _backgroundColorForCategory(item.category),
        borderRadius: BorderRadius.circular(AppSizes.r20),
        border: Border.all(color: _borderColorForCategory(item.category)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSizes.w40,
            height: AppSizes.h40,
            decoration: BoxDecoration(
              color: _iconColorForCategory(item.category).withAlpha(31),
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: _iconColorForCategory(item.category), size: AppSizes.sp22),
          ),
          SizedBox(width: AppSizes.w12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: AppStyles.black14500.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(width: AppSizes.w12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(item.timeLabel, style: AppStyles.tertiary40012),
                        SizedBox(height: AppSizes.h4),
                        // Container(
                        //   padding: EdgeInsets.symmetric(
                        //     horizontal: AppSizes.w8,
                        //     vertical: AppSizes.h4,
                        //   ),
                        //   decoration: BoxDecoration(
                        //     color: AppColors.surfaceColor.withAlpha(220),
                        //     borderRadius: BorderRadius.circular(AppSizes.r40),
                        //   ),
                        //   child: Text(
                        //   //  item.source.label,
                        //     style: TextStyle(
                        //       color: AppColors.primaryText,
                        //       fontSize: AppSizes.sp10,
                        //       fontWeight: FontWeight.w700,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.h4),
                Text(item.body, style: AppStyles.tertiary14400),
                if (!item.isRead) ...[
                  SizedBox(height: AppSizes.h10),
                  Row(
                    children: [
                      Container(
                        width: AppSizes.w8,
                        height: AppSizes.h8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: AppSizes.w8),
                      Text(
                        'Unread',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: AppSizes.sp12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationEmptyState extends StatelessWidget {
  const NotificationEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.w24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSizes.w80,
              height: AppSizes.h80,
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryText.withAlpha(12),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                size: AppSizes.sp32,
                color: AppColors.tertiaryText,
              ),
            ),
            SizedBox(height: AppSizes.h16),
            Text('No notifications found', style: AppStyles.black18500),
            SizedBox(height: AppSizes.h8),
            Text(
              'Try another category or wait for a new update.',
              textAlign: TextAlign.center,
              style: AppStyles.tertiary14400,
            ),
          ],
        ),
      ),
    );
  }
}

Color _backgroundColorForCategory(NotificationCategory category) {
  switch (category) {
    case NotificationCategory.medication:
      return const Color(0xFFEAFBF2);
    case NotificationCategory.health:
      return const Color(0xFFEAF2FF);
    case NotificationCategory.doctor:
      return const Color(0xFFFFF6E8);
    case NotificationCategory.all:
      return AppColors.surfaceColor;
  }
}

Color _borderColorForCategory(NotificationCategory category) {
  switch (category) {
    case NotificationCategory.medication:
      return const Color(0xFFB9EED0);
    case NotificationCategory.health:
      return const Color(0xFFB8D0FF);
    case NotificationCategory.doctor:
      return const Color(0xFFF8C3B5);
    case NotificationCategory.all:
      return AppColors.dividerColor;
  }
}

Color _iconColorForCategory(NotificationCategory category) {
  switch (category) {
    case NotificationCategory.medication:
      return const Color(0xFF1ACB71);
    case NotificationCategory.health:
      return const Color(0xFF4C84FF);
    case NotificationCategory.doctor:
      return const Color(0xFFF05A2B);
    case NotificationCategory.all:
      return AppColors.primaryText;
  }
}

IconData _iconForCategory(NotificationCategory category) {
  switch (category) {
    case NotificationCategory.medication:
      return Icons.medication_outlined;
    case NotificationCategory.health:
      return Icons.favorite_border_rounded;
    case NotificationCategory.doctor:
      return Icons.badge_outlined;
    case NotificationCategory.all:
      return Icons.notifications_none_rounded;
  }
}