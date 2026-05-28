import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/health_measurements/data/models/measurement_model.dart';
import 'package:medi/features/patient/features/health_measurements/presentation/widgets/measurement_grid_item.dart';

class HealthHeaderCard extends StatelessWidget {
  const HealthHeaderCard({
    super.key,
    required this.userName,
    required this.profileImagePath,
    required this.measurements,
    required this.onAddPressed,
  });

  final String userName;
  final String profileImagePath;
  final List<MeasurementModel> measurements;
  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.w24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSizes.r40),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipOval(
                child: SizedBox(
                  width: AppSizes.w40,
                  height: AppSizes.w40,
                  child: _buildAvatar(profileImagePath, _initials(userName)),
                ),
              ),
              SizedBox(width: AppSizes.w12),
              Expanded(
                child: Text(
                  userName,
                  style: TextStyle(
                    color: AppColors.whiteText,
                    fontSize: AppSizes.sp18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Material(
                color: AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(AppSizes.r200),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppSizes.r200),
                  onTap: onAddPressed,
                  child: SizedBox(
                    width: AppSizes.w40,
                    height: AppSizes.h40,
                    child: Icon(
                      Icons.add_rounded,
                      color: AppColors.primary,
                      size: AppSizes.sp22,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.h20),
          GridView.builder(
            shrinkWrap: true,
            itemCount: measurements.length,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSizes.h24,
              crossAxisSpacing: AppSizes.w12,
              childAspectRatio: AppSizes.w160 / AppSizes.h120,
            ),
            itemBuilder: (BuildContext context, int index) {
              return MeasurementGridItem(
                measurement: measurements[index],
                textColor: AppColors.whiteText,
                backgroundColor: AppColors.cardBackground,
              );
            },
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final List<String> parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((String part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      return 'U';
    }
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }

  Widget _buildAvatar(String imageSource, String initials) {
    if (imageSource.isEmpty) {
      return _AvatarInitials(initials: initials);
    }

    final lower = imageSource.toLowerCase();
    if (lower.startsWith('http://') || lower.startsWith('https://')) {
      return ColoredBox(
        color: AppColors.secondary,
        child: CachedNetworkImage(
          imageUrl: imageSource,
          fit: BoxFit.cover,
          fadeInDuration: Duration.zero,
          placeholder: (_, __) => _AvatarInitials(initials: initials),
          errorWidget: (_, __, ___) => _AvatarInitials(initials: initials),
        ),
      );
    }

    return Image.asset(
      imageSource,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _AvatarInitials(initials: initials),
    );
  }
}

class _AvatarInitials extends StatelessWidget {
  const _AvatarInitials({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.secondary,
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: AppSizes.sp14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
