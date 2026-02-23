
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/constants/app_assets.dart';
import 'package:medi/core/constants/app_colors.dart';
import 'package:medi/core/constants/app_sizes.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/widgets/primary_button.dart';

class PermissionSheet extends StatefulWidget {
  const PermissionSheet({super.key});

  @override
  State<PermissionSheet> createState() => _PermissionSheetState();
}

class _PermissionSheetState extends State<PermissionSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;
  late Animation<double> opacity;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    scale = Tween(
      begin: .9,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutBack));

    opacity = Tween(begin: 0.0, end: 1.0).animate(controller);

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.w16),
        child: 
             ScaleTransition(
              scale: scale,
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(AppSizes.r40)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 30,
                      color: Colors.black12,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppAssets.notifications,
                      height: AppSizes.h40,
                    ),

                    const SizedBox(height: 16),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(text: "Allow "),
                          TextSpan(
                            text: "Medi",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDark,
                            ),
                          ),
                          TextSpan(text: " to send you notifications?"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    PrimaryButton(
                      text: "Allow",
                      onPressed: () {
                       // Navigator.pop(context);
                        context.push(AppRouter.takeInfoScreen);
                      },
                    ),

                    const SizedBox(height: 12),
                    PrimaryButton(
                      text: "Don’t allow",
                      onPressed: () => Navigator.pop(context),
                      backgroundColor: Colors.white,
                      textColor: AppColors.primary,
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        
      
    );
  }
}
