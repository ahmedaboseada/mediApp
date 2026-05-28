import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/profile_qr.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserInfoScetion extends StatelessWidget {
  const UserInfoScetion({
    super.key,
    required this.name,
    required this.specialty,
    required this.userId,
    this.networkImageUrl,
    this.localImagePath,
    this.isLoading = false,
  });

  final String name;
  final String specialty;
  final String? networkImageUrl;
  final String? localImagePath;
  final bool isLoading;
  final String userId;
  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: Row(
        children: [
          SizedBox(
            width: AppSizes.w80,
            height: AppSizes.h80,
            child: ClipOval(
              child: isLoading
                  ? Container(color: Colors.white)
                  : Semantics(
                      image: true,
                      label: '$name profile photo',
                      child: _buildAvatarImageWith(networkImageUrl),
                    ),
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isLoading ? 'Loading Name' : name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                isLoading ? 'Loading Specialty' : specialty,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          Spacer(),
          //put the user id in the qr data
          ProfileQR(qrData: userId),
        ],
      ),
    );
  }

  Widget _buildAvatarImageWith(String? resolvedNetworkImageUrl) {
    if (localImagePath != null && localImagePath!.isNotEmpty) {
      return Image.file(File(localImagePath!), fit: BoxFit.cover);
    }

    if (resolvedNetworkImageUrl != null && resolvedNetworkImageUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: resolvedNetworkImageUrl,
        fit: BoxFit.cover,
        fadeInDuration: Duration.zero,
        placeholder: (_, __) => Image.asset(AppAssets.avatar1, fit: BoxFit.cover),
        errorWidget: (_, __, ___) => Image.asset(AppAssets.avatar1, fit: BoxFit.cover),
      );
    }

    return Image.asset(AppAssets.avatar1, fit: BoxFit.cover);
  }
}
