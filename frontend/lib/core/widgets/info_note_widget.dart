import 'package:flutter/cupertino.dart';
import 'package:medi/core/constants/app_colors.dart';
import 'package:medi/core/constants/app_sizes.dart';
import 'package:medi/core/utils/app_styles.dart';

class InfoNoteWidget extends StatelessWidget {
  final String text;
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;
  final TextStyle? textStyle;
  final double? spacing;

  const InfoNoteWidget({
    super.key,
    required this.text,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.textStyle,
    this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon ?? CupertinoIcons.info_circle,
          size: iconSize ?? AppSizes.h18,
          color: iconColor ?? AppColors.tertiaryText,
        ),
        SizedBox(width: spacing ?? AppSizes.w8),
        Expanded(
          child: Text(text, style: textStyle ?? AppStyles.tertiary40012),
        ),
      ],
    );
  }
}
