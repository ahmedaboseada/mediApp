import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class UserInfoScetion extends StatelessWidget {
  const UserInfoScetion({
    super.key,
    this.name = 'Dr. John Doe',
    this.specialty = 'Cardiologist',
    this.networkImageUrl,
    this.localImagePath,
  });

  final String name;
  final String specialty;
  final String? networkImageUrl;
  final String? localImagePath;

  Widget _buildAvatarImage() {
    if (localImagePath != null && localImagePath!.isNotEmpty) {
      return Image.file(File(localImagePath!), fit: BoxFit.cover);
    }

    if (networkImageUrl != null && networkImageUrl!.isNotEmpty) {
      return Image.network(
        networkImageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(AppAssets.avatar1, fit: BoxFit.cover);
        },
      );
    }

    return Image.asset(AppAssets.avatar1, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: AppSizes.w80,
          height: AppSizes.h80,
          child: ClipOval(child: _buildAvatarImage()),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              specialty,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}