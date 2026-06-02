import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';

class ConnectedPatientsSection extends StatelessWidget {
  const ConnectedPatientsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.w24),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF2FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.people_alt_outlined,
                  color: AppColors.primary,
                  size: AppSizes.sp22,
                ),
              ),
              title: Text('Connected Patients', style: AppStyles.black14500),
              // subtitle: Text(
              //   'Review incoming patient requests and manage your patient list.',
              //   style: AppStyles.secondary12400.copyWith(fontSize: AppSizes.sp8),
              // ),
              trailing: ElevatedButton(
                onPressed: () {
                  context.push(AppRouter.doctorIncomingPatientRequestsScreen);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 3.h,
                    horizontal: 10.w,
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'View Requests',
                  style: AppStyles.white16600.copyWith(fontSize: AppSizes.sp16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
