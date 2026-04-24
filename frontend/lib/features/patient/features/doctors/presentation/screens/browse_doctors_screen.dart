import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/doctors_cubit.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/doctors_state.dart';
import 'package:medi/features/patient/features/doctors/presentation/widgets/doctor_hover_card.dart';
import 'package:medi/features/patient/features/doctors/presentation/widgets/doctors_search_bar.dart';

class BrowseDoctorsScreen extends StatelessWidget {
  const BrowseDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DoctorsCubit>()..loadDoctors(),
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.w16,
              vertical: AppSizes.h12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DoctorsSearchBar(),
                SizedBox(height: AppSizes.h32),
                Expanded(
                  child: BlocBuilder<DoctorsCubit, DoctorsState>(
                    builder: (context, state) {
                      if (state is DoctorsLoading || state is DoctorsInitial) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is DoctorsError) {
                        return Center(child: Text(state.message));
                      } else if (state is DoctorsLoaded) {
                        final doctors = state.doctors;
                        if (doctors.isEmpty) {
                          return const Center(child: Text('No doctors found.'));
                        }
                        return GridView.builder(
                          padding: EdgeInsets.only(bottom: AppSizes.h12),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: AppSizes.w12,
                                mainAxisSpacing: AppSizes.h12,
                                childAspectRatio: 0.9,
                              ),
                          itemCount: doctors.length,
                          itemBuilder: (context, index) {
                            final doctor = doctors[index];
                            return DoctorHoverCard(
                              name:
                                  'Dr. ${doctor.user.firstName}\n${doctor.user.lastName}',
                              specialty: doctor.specialization,
                              rating: 4.5,
                              reviewsCount: doctor.reviewsCount,
                              imageAsset: doctor.user.profilePicture.isNotEmpty
                                  ? doctor.user.profilePicture
                                  : AppAssets.avatar1,
                              onTap: () => context.push(
                                '/doctors/profile',
                                extra: doctor,
                              ),
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
