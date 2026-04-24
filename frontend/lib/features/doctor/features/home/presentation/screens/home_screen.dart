import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return BlocProvider.value(
      value: _appointmentsCubit,
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: BlocBuilder<UserProfileCubit, UserProfileState>(
            builder: (context, state) {
              if (state is UserProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is UserProfileError) {
                return Center(child: Text(state.message));
              }

              if (state is UserProfileLoaded || state is UserProfileUpdated) {
                final profile = state.profile!;
                final user = profile.user;
                final doctorData = profile.doctor;
                final imageUrl = user.profilePicture;

                if (doctorData == null) {
                  return const Center(child: Text('Doctor profile not found'));
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DoctorHomeHeader(
                        name: "${user.firstName} ${user.lastName}",
                        specialization: doctorData.specialization,
                        id: doctorData.doctorId,
                        imageUrl: imageUrl,
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
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
