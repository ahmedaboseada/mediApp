import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medi/core/core.dart';

class PackageItem extends StatelessWidget {
  const PackageItem({
    super.key,
    required this.icon,
    required this.packageTitle,
    required this.packsubTitle,
    required this.priceTitle,
    required this.pricesubTitle,
    required this.selected,
    required this.onTap,
  });
  final String icon;
  final String packageTitle;
  final String packsubTitle;
  final String priceTitle;
  final String pricesubTitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return RadioGroup<bool>(
      groupValue: selected,
      onChanged: (_) => onTap(),
      child: Material(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(AppSizes.r8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.r8),
          child: Container(
            padding: EdgeInsets.all(AppSizes.w14),
            decoration: BoxDecoration(
              color: AppColors.surfaceColor,
              borderRadius: BorderRadius.circular(AppSizes.r8),
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.borderColor,
                width: selected ? 1.4 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: AppSizes.w48,
                  height: AppSizes.h48,
                  decoration: BoxDecoration(
                    color: AppColors.lightBackground,
                    borderRadius: BorderRadius.circular(AppSizes.r80),
                  ),
                  child: Center(child: SvgPicture.asset(icon)),
                ),
                SizedBox(width: AppSizes.w12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(packageTitle, style: AppStyles.black14500),
                      SizedBox(height: AppSizes.h4),
                      Text(packsubTitle, style: AppStyles.secondary12400),
                    ],
                  ),
                ),
                SizedBox(width: AppSizes.w10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(priceTitle, style: AppStyles.black14500),
                    SizedBox(height: AppSizes.h4),
                    Text(pricesubTitle, style: AppStyles.secondary12400),
                  ],
                ),
                SizedBox(width: AppSizes.w8),
                Radio<bool>(
                  value: true,
                  activeColor: AppColors.primary,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
