import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medi/core/core.dart';

class Role extends StatelessWidget {
  const Role({
    super.key,
    required this.role,
    required this.onTap,
    required this.imagePath,
  });
  final String role;
  final VoidCallback onTap;
  final String imagePath;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            width: AppSizes.w160,
            height: AppSizes.h160,
            decoration: BoxDecoration(
              color: Color(0xFF4690F9),
              borderRadius: BorderRadius.circular(AppSizes.r200),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(top: AppSizes.h12),
                child: SvgPicture.asset(imagePath),
              ),
            ),
          ),
        ),
        SizedBox(height: AppSizes.h16),
        Text(
          role,
          style: AppStyles.onboardingSubtitle.copyWith(fontSize: AppSizes.sp18),
        ),
      ],
    );
  }
}
