import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/home/presentation/cubit/appointments_cubit.dart';
import 'package:medi/features/doctor/features/home/presentation/widgets/doctor_appointments_section.dart';
import 'package:medi/features/doctor/features/home/presentation/widgets/doctor_home_header.dart';
import 'package:medi/features/patient/features/doctors/presentation/widgets/doctor_profile_calendar.dart';
import 'package:medi/features/shared/auth/presentation/cubit/user_profile/user_profile_cubit.dart';
import 'package:medi/features/shared/auth/presentation/cubit/user_profile/user_profile_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ValueNotifier<DateTime?> _selectedDate;
  late final AppointmentsCubit _appointmentsCubit;

  @override
  void initState() {
    super.initState();
    _selectedDate = ValueNotifier<DateTime?>(DateTime.now());
    _appointmentsCubit = getIt<AppointmentsCubit>();
    _selectedDate.addListener(_onSelectedDateChanged);
    _appointmentsCubit.loadAppointmentsForDate(
      _selectedDate.value ?? DateTime.now(),
    );
  }

  @override
  void dispose() {
    _selectedDate.removeListener(_onSelectedDateChanged);
    _selectedDate.dispose();
    _appointmentsCubit.close();
    super.dispose();
  }

  void _onSelectedDateChanged() {
    final selected = _selectedDate.value;
    if (selected == null) {
      return;
    }
    _appointmentsCubit.loadAppointmentsForDate(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<UserProfileCubit, UserProfileState>(
          builder: (context, state) {
            final isLoading = state is UserProfileLoading;

            if (state is UserProfileError) {
              return Center(child: Text(state.message));
            }

            if (state is UserProfileLoaded ||
                state is UserProfileUpdated ||
                isLoading) {
              final profile = state.profile;
              final user = profile?.user;
              final doctorData = profile?.doctor;

              final name = user != null
                  ? "${user.firstName} ${user.lastName}"
                  : "Doctor Name Placeholder";
              final specialization =
                  doctorData?.specialization ?? "Specialization Placeholder";
              final id = doctorData?.doctorId ?? "ID-12345";
              final imageUrl = user?.profilePicture ?? "";

              return SingleChildScrollView(
                child: BlocProvider.value(
                  value: _appointmentsCubit,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Skeletonizer(
                        enabled: isLoading,
                        child: DoctorHomeHeader(
                          name: name,
                          specialization: specialization,
                          id: id,
                          imageUrl: imageUrl,
                        ),
                      ),
                      SizedBox(height: AppSizes.h16),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSizes.w16),
                        child: Column(
                          children: [
                            DoctorProfileCalendar(selectedDate: _selectedDate),
                            SizedBox(height: AppSizes.h20),
                            const DoctorAppointmentsSection(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
