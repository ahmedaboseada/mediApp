import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class DoctorsSearchBar extends StatelessWidget {
  const DoctorsSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onFilterTap,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: AppSizes.h40,
            padding: EdgeInsets.symmetric(horizontal: AppSizes.w12),
            decoration: BoxDecoration(
              color: AppColors.surfaceColor,
              borderRadius: BorderRadius.circular(AppSizes.r40),
            ),
            child: Row(
              children: [
                SizedBox(width: AppSizes.w8),
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: onChanged,
                    decoration: InputDecoration(
                      hintText: 'Search for doctors',
                      hintStyle: AppStyles.tertiary14500,
                      border: OutlineInputBorder(
                        borderRadius:  BorderRadius.all(Radius.circular(40)),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        borderSide: BorderSide.none,
                      ),
                      isDense: true,

                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.secondaryText,
                        size: AppSizes.sp20,
                      ),
                    ),
                    style: AppStyles.black14500,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: AppSizes.w10),
        Material(
          color: AppColors.surfaceColor,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onFilterTap,
            child: SizedBox(
              height: AppSizes.h40,
              width: AppSizes.h40,
              child: Icon(
                Icons.tune,
                color: AppColors.secondaryText,
                size: AppSizes.sp20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
