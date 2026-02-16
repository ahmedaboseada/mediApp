import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/constants/app_colors.dart';
import 'package:medi/core/constants/app_sizes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Container(
          height: AppSizes.h40,
          width: AppSizes.w40,
          decoration: BoxDecoration(
            color: AppColors.whiteText,
            borderRadius: BorderRadius.circular(AppSizes.r80),
          ),
          child: const Icon(Icons.arrow_back_ios),
        ),
        onPressed: () {
          context.pop(context);
        },
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
