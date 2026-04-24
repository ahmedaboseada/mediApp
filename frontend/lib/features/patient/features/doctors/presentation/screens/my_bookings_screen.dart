import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/doctors/data/models/doctor_summary.dart';
import 'package:medi/features/patient/features/doctors/presentation/widgets/add_review_dialog.dart';
import 'package:medi/features/patient/features/doctors/presentation/widgets/appointment_card.dart';
import 'package:medi/features/patient/features/doctors/presentation/widgets/reschedule_appointment_dialog.dart';
import 'package:medi/features/patient/features/doctors/presentation/widgets/success_top_banner.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  OverlayEntry? _successOverlayEntry;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _successOverlayEntry?.remove();
    _successOverlayEntry = null;
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Booking',
        actionIcon: Icons.search,
        onpressed: () {},
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.secondaryText,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'Upcoming'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Upcoming Appointments
                _buildAppointmentsList(
                  appointments: _upcomingAppointments,
                  emptyMessage: 'No upcoming appointments',
                ),
                // Completed Appointments
                _buildAppointmentsList(
                  appointments: _completedAppointments,
                  emptyMessage: 'No completed appointments',
                ),
                // Cancelled Appointments
                _buildAppointmentsList(
                  appointments: _cancelledAppointments,
                  emptyMessage: 'No cancelled appointments',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList({
    required List<AppointmentInfo> appointments,
    required String emptyMessage,
  }) {
    if (appointments.isEmpty) {
      return Center(child: Text(emptyMessage, style: AppStyles.secondary12400));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSizes.w16),
      child: Column(
        children: [
          ...appointments.map(
            (appointment) => Padding(
              padding: EdgeInsets.only(bottom: AppSizes.h12),
              child: AppointmentCard(
                appointment: appointment,
                onSecondaryActionPressed: () {
                  _handleSecondaryAction(appointment);
                },
                onPrimaryActionPressed: () {
                  _handlePrimaryAction(appointment);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSecondaryAction(AppointmentInfo appointment) {
    if (appointment.status == 'upcoming') {
      context.push(AppRouter.patientCancelBookingScreen);
      return;
    }

    if (appointment.status == 'completed') {
      context.push(
        AppRouter.doctorProfileScreen,
        extra: appointment.doctorName,
      );
      return;
    }

    final action = appointment.status == 'upcoming' ? 'Cancel' : 'Re-Book';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$action tapped for ${appointment.doctorName}')),
    );
  }

  // DoctorModel _mapAppointmentDoctor(AppointmentInfo appointment) {
  //   return DoctorModel(
  //     id: appointment.doctorName.toLowerCase().replaceAll(' ', '_'),
  //     name: appointment.doctorName,
  //     specialty: 'General Physician',
  //     rating: 4.8,
  //     reviewsCount: 82,
  //     imageAsset: AppAssets.avatar1,
  //   );
  // }

  void _handlePrimaryAction(AppointmentInfo appointment) {
    if (appointment.status == 'upcoming') {
      showDialog<void>(
        context: context,
        builder: (context) {
          return RescheduleAppointmentDialog(
            doctorName: appointment.doctorName,
            onReschedule: () {
              _showTopSuccessBanner('New appointment added');
            },
          );
        },
      );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (context) {
        return AddReviewDialog(onRate: (_) {});
      },
    );
  }

  void _showTopSuccessBanner(String message) {
    _successOverlayEntry?.remove();

    final overlay = Overlay.maybeOf(context);
    if (overlay == null) {
      return;
    }

    _successOverlayEntry = OverlayEntry(
      builder: (overlayContext) {
        return Positioned(
          top: MediaQuery.of(overlayContext).padding.top + AppSizes.h8,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: Center(child: SuccessTopBanner(message: message)),
          ),
        );
      },
    );

    overlay.insert(_successOverlayEntry!);

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) {
        return;
      }
      _successOverlayEntry?.remove();
      _successOverlayEntry = null;
    });
  }

  // Sample data
  static final List<AppointmentInfo> _upcomingAppointments = [
    AppointmentInfo(
      dateTime: 'Aug 25, 2026 - 10:00 AM',
      doctorName: 'Dr. Jenny William',
      location: 'G8502 Preston Rd. Inglewood',
      bookingId: '#DR452SA54',
      remindMe: true,
      status: 'upcoming',
    ),
    AppointmentInfo(
      dateTime: 'Aug 25, 2026 - 10:00 AM',
      doctorName: 'Dr. Guy Hawkins',
      location: 'G8502 Preston Rd. Inglewood',
      bookingId: '#DR452SA54',
      remindMe: true,
      status: 'upcoming',
    ),
  ];

  static final List<AppointmentInfo> _completedAppointments = [
    AppointmentInfo(
      dateTime: 'Aug 18, 2026 - 2:00 PM',
      doctorName: 'Dr. Sarah Johnson',
      location: 'G8502 Preston Rd. Inglewood',
      bookingId: '#DR451SA53',
      remindMe: false,
      status: 'completed',
    ),
  ];

  static final List<AppointmentInfo> _cancelledAppointments = [
    AppointmentInfo(
      dateTime: 'Aug 10, 2026 - 3:30 PM',
      doctorName: 'Dr. Michael Brown',
      location: 'G8502 Preston Rd. Inglewood',
      bookingId: '#DR450SA52',
      remindMe: false,
      status: 'cancelled',
    ),
  ];
}

class AppointmentInfo {
  final String dateTime;
  final String doctorName;
  final String location;
  final String bookingId;
  final bool remindMe;
  final String status; // upcoming, completed, cancelled

  AppointmentInfo({
    required this.dateTime,
    required this.doctorName,
    required this.location,
    required this.bookingId,
    required this.remindMe,
    required this.status,
  });
}
