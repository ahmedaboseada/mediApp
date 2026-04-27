import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';

class UserWidget extends StatelessWidget {
  const UserWidget({
    super.key,
    required this.firstName,
    this.profileImagePath = '',
  });

  final String firstName;
  final String profileImagePath;

  @override
  Widget build(BuildContext context) {
    final displayName = firstName.trim().isEmpty ? 'User' : firstName.trim();

    return GestureDetector(
      onTap: () {
        context.go('/profile');
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.w16,
          vertical: AppSizes.h6,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.all(Radius.circular(AppSizes.r40)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: AppSizes.r20,
              backgroundColor: AppColors.secondary,
              foregroundImage: _resolveImageProvider(profileImagePath),
              child: Text(
                _initials(displayName),
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: AppSizes.sp14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            SizedBox(width: AppSizes.w12),
            Text('Hi, $displayName!', style: AppStyles.black18500),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return 'U';
    }

    return parts.first.substring(0, 1).toUpperCase();
  }

  ImageProvider? _resolveImageProvider(String imageSource) {
    if (imageSource.isEmpty) {
      return null;
    }

    final lower = imageSource.toLowerCase();
    if (lower.startsWith('http://') || lower.startsWith('https://')) {
      return NetworkImage(imageSource);
    }

    return AssetImage(imageSource);
  }
}
