import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/section_item_tile.dart';

class ConnectedDoctorsSection extends StatelessWidget {
  const ConnectedDoctorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.w24),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: SvgPicture.asset(
                AppAssets.connectedDoctors,
                width: 24,
                height: 24,
              ),
              title: Text("Connected Doctors", style: AppStyles.black18500),
              trailing: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 6.w),
                  elevation: 0,
                ),
                child: Text(
                  "Add",
                  style: AppStyles.white16600.copyWith(fontSize: AppSizes.sp18),
                ),
              ),
            ),
            SizedBox(height: 20),
            SectionItemTile(
              title: "Dr. John Doe",
              trailingIcon: Icon(
                Icons.arrow_forward_ios,
                color: AppColors.primary,
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
