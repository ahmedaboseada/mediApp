import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/home/presentation/cubit/appointments_cubit.dart';
import 'package:medi/features/doctor/features/home/presentation/widgets/doctor_appointments_section.dart';
import 'package:medi/features/doctor/features/home/presentation/widgets/doctor_home_header.dart';
import 'package:medi/features/patient/features/doctors/presentation/widgets/doctor_profile_calendar.dart';
import 'package:medi/features/shared/auth/presentation/cubit/user_profile/user_profile_cubit.dart';
import 'package:medi/features/shared/auth/presentation/cubit/user_profile/user_profile_state.dart';
import 'package:medi/features/doctor/features/patients/presentation/screens/qr_scanner_screen.dart';
import 'package:medi/features/patient/features/profile/presentation/controller/health_passport_export/health_passport_export_cubit.dart';
import 'package:medi/features/patient/features/profile/presentation/controller/health_passport_export/health_passport_export_state.dart';
import 'package:medi/features/patient/features/profile/data/repo/profile_repo.dart';
import 'package:open_filex/open_filex.dart';

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

  Future<void> _openQRScanner(BuildContext context) async {
    final qrToken = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => const QrScannerScreen(),
      ),
    );

    if (qrToken != null && qrToken.isNotEmpty && mounted) {
      final choice = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Download Options'),
          content: const Text('What would you like to download?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop('passport'),
              child: const Text('Health Passport', style: TextStyle(color: AppColors.primary)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop('report'),
              child: const Text('Health Report', style: TextStyle(color: AppColors.primary)),
            ),
          ],
        ),
      );

      if (choice != null && mounted) {
        if (choice == 'report') {
          _downloadSharedRecord(context, qrToken, endpointPath: '/export/shared/report/$qrToken');
        } else {
          _downloadSharedRecord(context, qrToken);
        }
      }
    }
  }

  void _downloadSharedRecord(BuildContext context, String qrToken, {String? endpointPath}) {
    final downloadCubit = SharedRecordDownloadCubit(getIt<ProfileRepo>());

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: downloadCubit,
        child: BlocListener<SharedRecordDownloadCubit, SharedRecordDownloadState>(
          listener: (context, state) {
            if (state is SharedRecordDownloadSuccess) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Record downloaded successfully'),
                  backgroundColor: Colors.green,
                ),
              );
              OpenFilex.open(state.filePath);
            } else if (state is SharedRecordDownloadFailure) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to download: ${state.error}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );

    // Trigger download
    downloadCubit.downloadSharedRecord(qrToken, endpointPath: endpointPath);
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
                  doctorData?.specialization ?? "";
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
                          onInsightsTap: () {
                            context.push(AppRouter.doctorNotificationsScreen);
                          },
                          onQRScan: () => _openQRScanner(context),
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
