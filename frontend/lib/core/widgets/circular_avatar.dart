import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medi/core/core.dart';

class CircularAvatar extends StatelessWidget {
  const CircularAvatar({
    super.key,
    this.selectedImagePath,
    this.networkImageUrl,
    this.size,
  });

  final String? selectedImagePath;
  final String? networkImageUrl;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final avatarSize = size ?? AppSizes.h120;

    return Stack(
      children: [
        Container(
          height: avatarSize,
          width: avatarSize,
          decoration: BoxDecoration(shape: BoxShape.circle),
          //clipBehavior: Clip.antiAlias,
          child: selectedImagePath != null
              ? Image.file(File(selectedImagePath!), fit: BoxFit.cover)
              : (networkImageUrl != null && networkImageUrl!.isNotEmpty)
              ? Image.network(
                  networkImageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, err, builder) => Icon(Icons.person),
                )
              : Image.asset(
                  AppAssets.avatar1,
                  height: AppSizes.h120,
                  width: AppSizes.w120,
                ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            height: AppSizes.h34,
            width: AppSizes.w34,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              height: AppSizes.h18,
              width: AppSizes.w18,
              AppAssets.lineEdit,
              fit: BoxFit.scaleDown,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
