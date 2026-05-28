import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medi/core/constants/app_colors.dart';
import 'package:medi/core/constants/app_sizes.dart';
import 'package:medi/core/services/hive_service.dart';
import 'package:medi/core/utils/app_router.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<dynamic>>(
      valueListenable: HiveService.listenableSettingsBox(
        keys: [HiveService.unreadNotificationsCountKey],
      ),
      builder: (context, box, child) {
        final unreadCount =
            box.get(HiveService.unreadNotificationsCountKey, defaultValue: 0)
                as int;
        return _ButtonShell(
          unreadCount: unreadCount,
          onTap: () => context.push(AppRouter.notificationsScreen),
        );
      },
    );
  }
}

class _ButtonShell extends StatelessWidget {
  const _ButtonShell({
    required this.unreadCount,
    required this.onTap,
  });

  final int unreadCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final badgeText = unreadCount > 99 ? '99+' : unreadCount.toString();

    return Semantics(
      button: true,
      label: unreadCount > 0
          ? 'Notifications, $unreadCount unread'
          : 'Notifications',
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: AppSizes.w48,
              height: AppSizes.h48,
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryText.withAlpha(20),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                color: AppColors.primaryText,
                size: AppSizes.sp24,
              ),
            ),
            if (unreadCount > 0)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.w4,
                    vertical: AppSizes.h4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(AppSizes.r40),
                    border: Border.all(
                      color: AppColors.background,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      color: AppColors.whiteText,
                      fontSize: AppSizes.sp10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}