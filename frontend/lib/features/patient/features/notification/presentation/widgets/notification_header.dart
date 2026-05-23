import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class NotificationHeader extends StatelessWidget {
  const NotificationHeader({
    super.key,
    required this.unreadCount,
    required this.onBackPressed,
  });

  final int unreadCount;
  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _HeaderIconButton(onTap: onBackPressed),
        Expanded(
          child: Center(
            child: Text('Notification', style: AppStyles.black18500),
          ),
        ),
        if (unreadCount > 0)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.w10,
              vertical: AppSizes.h6,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppSizes.r40),
            ),
            child: Text(
              unreadCount > 99 ? '99+ NEW' : '$unreadCount NEW',
              style: AppStyles.white12400,
            ),
          )
        else
          SizedBox(width: AppSizes.w40),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSizes.w40,
        height: AppSizes.h40,
        decoration: const BoxDecoration(
          color: AppColors.surfaceColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: AppSizes.sp18,
          color: AppColors.primaryText,
        ),
      ),
    );
  }
}