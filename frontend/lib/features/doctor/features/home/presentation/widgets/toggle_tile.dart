import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class ToggleTile extends StatelessWidget {
  const ToggleTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minTileHeight: 16,
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: AppStyles.fieldLabel50014),
      subtitle: subtitle != null
          ? Text(subtitle!, style: AppStyles.dividerText40012)
          : null,
      trailing: CustomToggleSwitch(value: value, onChanged: onChanged),
    );
  }
}
