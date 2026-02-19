import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/splash/presentation/widgets/role.dart';

class SelectScreen extends StatelessWidget {
  const SelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.68,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(AppSizes.r200),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.68,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Select what you are',
                        textAlign: TextAlign.center,
                        style: AppStyles.white24700,
                      ),
                      SizedBox(height: AppSizes.h56),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSizes.w16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Role(
                              role: UserRole.doctor.title,
                              onTap: () {
                                context.go(AppRouter.doctorLogin);
                              },
                              imagePath: AppAssets.doctor,
                            ),

                            Role(
                              role: UserRole.patient.title,
                              onTap: () {
                                context.go(AppRouter.patientLogin);
                              },
                              imagePath: AppAssets.patient,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
