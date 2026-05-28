import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
            _UserAvatar(
              initials: _initials(displayName),
              profileImagePath: profileImagePath,
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
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({
    required this.initials,
    required this.profileImagePath,
  });

  final String initials;
  final String profileImagePath;

  @override
  Widget build(BuildContext context) {
    final isNetworkImage = profileImagePath.toLowerCase().startsWith('http');

    return ClipOval(
      child: SizedBox(
        width: AppSizes.w40,
        height: AppSizes.w40,
        child: ColoredBox(
          color: AppColors.secondary,
          child: isNetworkImage
              ? CachedNetworkImage(
                  imageUrl: profileImagePath,
                  fit: BoxFit.cover,
                  fadeInDuration: Duration.zero,
                  placeholder: (_, _) => _AvatarInitials(initials: initials),
                  errorWidget: (_, _, _) => _AvatarInitials(initials: initials),
                )
              : profileImagePath.isNotEmpty
                  ? Image.asset(
                      profileImagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _AvatarInitials(initials: initials),
                    )
                  : _AvatarInitials(initials: initials),
        ),
      ),
    );
  }
}

class _AvatarInitials extends StatelessWidget {
  const _AvatarInitials({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initials,
        style: TextStyle(
          color: AppColors.primary,
          fontSize: AppSizes.sp14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
