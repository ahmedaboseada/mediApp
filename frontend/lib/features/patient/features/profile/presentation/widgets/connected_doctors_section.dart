import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/connected_doctors_cubit.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/connected_doctors_state.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/section_item_tile.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
                onPressed: () {
                  context.push(AppRouter.patientAddDoctorScreen);
                },
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
            BlocBuilder<ConnectedDoctorsCubit, ConnectedDoctorsState>(
              builder: (context, state) {
                final isLoading = state is ConnectedDoctorsLoading;

                if (state is ConnectedDoctorsError) {
                  return Center(
                    child: Text(state.message, style: AppStyles.secondary12400),
                  );
                }

                if (state is ConnectedDoctorsLoaded || isLoading) {
                  final doctors = state is ConnectedDoctorsLoaded
                      ? state.doctors
                      : [];

                  if (!isLoading && doctors.isEmpty) {
                    return Center(
                      child: Text(
                        "No connected doctors yet",
                        style: AppStyles.secondary12400,
                      ),
                    );
                  }

                  return Skeletonizer(
                    enabled: isLoading,
                    child: Column(
                      children: isLoading
                          ? List.generate(
                              2,
                              (index) => SectionItemTile(
                                title: 'Dr. Doctor Name Placeholder',
                                trailingIcon: Icon(
                                  Icons.arrow_forward_ios,
                                  color: AppColors.primary,
                                ),
                                onTap: () {},
                              ),
                            )
                          : doctors.map((doctor) {
                              return SectionItemTile(
                                title:
                                    'Dr. ${doctor.user.firstName} ${doctor.user.lastName}',
                                trailingIcon: Icon(
                                  Icons.arrow_forward_ios,
                                  color: AppColors.primary,
                                ),
                                onTap: () {
                                  context.push(
                                    AppRouter.doctorProfileScreen,
                                    extra: doctor,
                                  );
                                },
                              );
                            }).toList(),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
