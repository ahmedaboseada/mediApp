import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const SettingsTile({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        // horizontal: AppSizes.h24,
        vertical: 0,
      ),
      title: Text(title, style: AppStyles.cardtitle40016),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: AppSizes.h16,
        color: AppColors.primaryDark,
      ),
      onTap: onTap,
    );
  }
}
