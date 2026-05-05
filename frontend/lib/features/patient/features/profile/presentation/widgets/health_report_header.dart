import 'dart:io';
import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HealthReportHeader extends StatelessWidget {
  const HealthReportHeader({
    super.key,
    required this.name,
    required this.gender,
    required this.age,

    this.networkImageUrl,
    this.localImagePath,
    this.isLoading = false,
  });

  final String name;
  final String gender;
  final String age;
  final String? networkImageUrl;
  final String? localImagePath;
  final bool isLoading;
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
                  : _buildAvatarImageWith(networkImageUrl),
            ),
          ),
          SizedBox(width: AppSizes.w16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isLoading ? 'Loading Name' : name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: AppSizes.h16),
              Row(
                children: [
                  Text(
                    isLoading ? 'Loading Gender' : gender=='female' ? '♀' : '♂',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(width: AppSizes.w8),
                  Text(
                    isLoading ? 'Loading Age' : "$age Years",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarImageWith(String? resolvedNetworkImageUrl) {
    if (localImagePath != null && localImagePath!.isNotEmpty) {
      return Image.file(File(localImagePath!), fit: BoxFit.cover);
    }

    if (resolvedNetworkImageUrl != null && resolvedNetworkImageUrl.isNotEmpty) {
      return Image.network(
        resolvedNetworkImageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(AppAssets.avatar1, fit: BoxFit.cover);
        },
      );
    }

    return Image.asset(AppAssets.avatar1, fit: BoxFit.cover);
  }
}
