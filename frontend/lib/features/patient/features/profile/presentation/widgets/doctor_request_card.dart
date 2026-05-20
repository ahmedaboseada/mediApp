import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class DoctorRequestCard extends StatelessWidget {
  final String name;
  final String specialty;
  final String clinicName;
  final String? profilePicture;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const DoctorRequestCard({
    super.key,
    required this.name,
    required this.specialty,
    required this.clinicName,
    this.profilePicture,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSizes.h12),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.w16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: AppSizes.w48,
                  height: AppSizes.h48,
                  child: ClipOval(
                    child: profilePicture != null && profilePicture!.isNotEmpty
                        ? Image.network(profilePicture!, fit: BoxFit.cover)
                        : Container(
                            color: AppColors.surfaceColor,
                            child: Icon(
                              Icons.person,
                              color: AppColors.secondary,
                            ),
                          ),
                  ),
                ),
                SizedBox(width: AppSizes.w12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: AppStyles.black14500),
                      if (specialty.isNotEmpty)
                        Text(specialty, style: AppStyles.secondary12400),
                      if (clinicName.isNotEmpty)
                        Text(clinicName, style: AppStyles.tertiary14400),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.h16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: AppSizes.h12),
                    ),
                    onPressed: onAccept,
                    child: Text(
                      'Accept',
                      style: AppStyles.white14500.copyWith(
                        fontSize: AppSizes.sp14,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppSizes.w12),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: AppSizes.h12),
                    ),
                    onPressed: onReject,
                    child: Text(
                      'Reject',
                      style: AppStyles.primary18700.copyWith(
                        fontSize: AppSizes.sp14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
