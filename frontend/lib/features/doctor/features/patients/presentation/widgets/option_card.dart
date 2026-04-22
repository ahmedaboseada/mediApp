import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class OptionCard extends StatelessWidget {
  const OptionCard({
    super.key,
    required this.icon,
    required this.iconBackgroundColor,
    required this.title,
    required this.description,
    required this.isExpanded,
    required this.onTap,
    this.expandedChild,
  });

  final IconData icon;
  final Color iconBackgroundColor;
  final String title;
  final String description;
  final bool isExpanded;
  final VoidCallback onTap;
  final Widget? expandedChild;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.r40),
        child: Container(
          padding: EdgeInsets.all(AppSizes.w16),
          decoration: BoxDecoration(
            color: isExpanded
                ? AppColors.lightBackground
                : AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(AppSizes.r40),
            border: Border.all(
              color: isExpanded ? AppColors.primary : AppColors.borderColor,
              width: 1,
            ),
          ),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(AppSizes.w12),
                      decoration: BoxDecoration(
                        color: iconBackgroundColor,
                        borderRadius: BorderRadius.circular(AppSizes.r12),
                      ),
                      child: Icon(
                        icon,
                        color: AppColors.primary,
                        size: AppSizes.w24,
                      ),
                    ),
                    SizedBox(width: AppSizes.w16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(title, style: AppStyles.black14600),
                          SizedBox(height: AppSizes.h4),
                          Text(
                            description,
                            style: AppStyles.tertiary14400,
                            maxLines: isExpanded ? null : 2,
                            overflow: isExpanded
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (isExpanded && expandedChild != null) expandedChild!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
