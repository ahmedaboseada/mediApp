import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medi/core/core.dart';

class StockExpiryCard extends StatelessWidget {
  const StockExpiryCard({
    super.key,
    required this.stock,
    required this.expiryDate,
    required this.onRefill,
  });

  final int stock;
  final String expiryDate;
  final VoidCallback onRefill;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 700),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 25 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(AppSizes.w20),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(AppSizes.r16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  AppAssets.medicineBox,
                  width: 24,
                  height: 24,
                  color: AppColors.secondaryText,
                ),
                SizedBox(width: AppSizes.w8),
                Text(
                  'Stock & Expiry',
                  style: TextStyle(
                    fontSize: AppSizes.sp16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.h16),
            Row(
              children: [
                Expanded(
                  child: _InfoBlock(
                    icon: Icons.water_drop_outlined,
                    label: 'Current Stock',
                    value: '$stock units',
                    iconColor: const Color(0xFF2178F3),
                  ),
                ),
                SizedBox(width: AppSizes.w12),
              ],
            ),
            SizedBox(height: AppSizes.h16),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(onPressed: onRefill, text: 'Refill '),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.w12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(AppSizes.r12),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 28),
          SizedBox(height: AppSizes.h8),
          Text(
            value,
            style: TextStyle(
              fontSize: AppSizes.sp16,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryText,
            ),
          ),
          SizedBox(height: AppSizes.h4),
          Text(
            label,
            style: TextStyle(
              fontSize: AppSizes.sp12,
              fontWeight: FontWeight.w400,
              color: AppColors.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
