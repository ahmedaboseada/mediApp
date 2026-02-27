import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medi/core/core.dart';

class SectionItemTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailingIcon;
  final String? trailingAsset;
  final VoidCallback? onTap;

  const SectionItemTile({
    super.key,
    required this.title,
    this.subtitle,
    this.trailingIcon= const Icon(  Icons.arrow_forward_ios ,color: AppColors.primary,size: 16,),
    this.trailingAsset,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(title, style: AppStyles.black16400),
          subtitle: subtitle != null ? Text(subtitle!, style: AppStyles.secondary12400) : null,
          trailing: trailingIcon ??
              (trailingAsset != null
                  ? SvgPicture.asset(trailingAsset!, width: 24, height: 24)
                  : null),
        ),
      ),
    );
  }
}