import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/complete_profile/data/repo/doctor_complete_profile_repo.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/controller/cubit/location_cubit.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/controller/cubit/location_state.dart';

class AllowLocationScreen extends StatelessWidget {
  const AllowLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocationCubit(getIt<DoctorCompleteProfileRepo>()),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.w16,
              vertical: AppSizes.h32,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Circular icon
                Container(
                  width: AppSizes.w120,
                  height: AppSizes.h120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF4F8DF7).withOpacity(0.15),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.location_on_rounded,
                      color: AppColors.primary,
                      size: AppSizes.h50,
                    ),
                  ),
                ),
                SizedBox(height: AppSizes.h32),

                Text(
                  AppStrings.clinicLocationTitle,
                  textAlign: TextAlign.center,
                  style: AppStyles.black24700,
                ),
                SizedBox(height: AppSizes.h8),
                Text(
                  AppStrings.clinicLocationSubtitle,
                  textAlign: TextAlign.center,
                  style: AppStyles.tertiary14500,
                ),
                SizedBox(height: AppSizes.h40),

                BlocConsumer<LocationCubit, LocationState>(
                  listener: (context, state) async {
                    if (state is LocationFailure) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.error)));
                    }
                    if (state is LocationSuccess) {
                      await HiveService.markCompleteProfileAsCompleted();
                      if (!context.mounted) {
                        return;
                      }
                      context.go(AppRouter.doctorProfileCompletedScreen);
                    }
                  },
                  builder: (context, state) {
                    if (state is LocationLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return PrimaryButton(
                      text: AppStrings.allowLocationAccess,
                      onPressed: () {
                        context.read<LocationCubit>().getCurrentLocation();
                      },
                    );
                  },
                ),

                SizedBox(height: AppSizes.h24),

                CustomTextButton2(
                  label: AppStrings.enterLocationManually,
                  route: AppRouter.manualLocationScreen,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
