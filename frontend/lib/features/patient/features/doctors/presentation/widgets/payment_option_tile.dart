import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class PaymentOptionTile<T> extends StatelessWidget {
  const PaymentOptionTile({
    super.key,
    required this.title,
    required this.value,
    this.leading,
    this.hasBorder = false,
    this.onTap,
  });

  final String title;
  final T value;
  final Widget? leading;
  final bool hasBorder;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radioGroup = RadioGroup.maybeOf<T>(context);

    return InkWell(
      onTap: () {
        radioGroup?.onChanged(value);
        onTap?.call();
      },
      borderRadius: BorderRadius.circular(AppSizes.r12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.w12,
          vertical: AppSizes.h12,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(AppSizes.r12),
          border: Border.all(
            color: hasBorder ? Colors.transparent : AppColors.borderColor,
          ),
        ),
        child: Row(
          children: [
            leading ??
                Icon(
                  Icons.credit_card_rounded,
                  color: AppColors.primary,
                  size: AppSizes.sp20,
                ),
            SizedBox(width: AppSizes.w10),
            Expanded(
              child: Text(
                title,
                style: AppStyles.black14500.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
            ),
            Radio<T>(
              value: value,
              activeColor: AppColors.primary,
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }
}
