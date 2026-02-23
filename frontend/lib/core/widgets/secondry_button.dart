import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';


class SecondryButton extends StatelessWidget {
  const SecondryButton({
   super.key,
    this.backgroundColor = AppColors.secondary,
    this.textColor = AppColors.primary,
    this.text,
    this.borderRadius = const BorderRadius.all(Radius.circular(80)),
    this.onPressed,
    this.child,
    });
  final Color backgroundColor;
  final Color textColor;
  final String? text;
  final BorderRadius borderRadius;
  final Function()? onPressed;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        //side: BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(borderRadius: borderRadius,),
        padding: EdgeInsets.symmetric(vertical:AppSizes.h12, horizontal:AppSizes.w40),
        elevation: 0,
      ),
      child:
          child ??
          Text(
            text ?? '',
            style: TextStyle(
              color: textColor,
              fontSize: AppSizes.sp16,
              fontWeight: FontWeight.w600,
            ),
          ),
    );
  }
}

