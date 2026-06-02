import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/doctors/data/models/booking_model.dart';
import 'package:medi/features/patient/features/doctors/data/repo/doctors_repo.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/booking_qr_cubit.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/booking_qr_state.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/review_cubit.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/review_state.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/my_bookings_cubit.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/my_bookings_state.dart';
import 'package:medi/features/patient/features/doctors/presentation/widgets/add_review_dialog.dart';
import 'package:medi/features/patient/features/doctors/presentation/widgets/appointment_card.dart';
import 'package:medi/features/patient/features/doctors/presentation/widgets/reschedule_appointment_dialog.dart';
import 'package:medi/features/patient/features/doctors/presentation/widgets/success_top_banner.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/profile_qr.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              MyBookingsCubit(doctorsRepository: getIt<DoctorsRepository>())
                ..fetchBookings(),
        ),
        BlocProvider(create: (context) => getIt<BookingQrCubit>()),
        BlocProvider(
          create: (context) =>
              ReviewCubit(doctorsRepository: getIt<DoctorsRepository>()),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<BookingQrCubit, BookingQrState>(
            listener: (context, state) {
          if (state is BookingQrFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }

          if (state is BookingQrSuccess) {
            showDialog(
              context: context,
              builder: (_) => QrDialog(qrData: state.sessionToken),
            );
          }
        },
          ),
          BlocListener<ReviewCubit, ReviewState>(
            listener: (context, state) {
              if (state is ReviewSubmitting) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Submitting rating...')),
                );
              }

              if (state is ReviewFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }

              if (state is ReviewSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message ?? 'Rating submitted')),
                );
                try {
                  context.read<MyBookingsCubit>().fetchBookings();
                } catch (_) {}
              }
            },
          ),
        ],
        child: Builder(
          builder: (context) {
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
                    child: BlocBuilder<MyBookingsCubit, MyBookingsState>(
                      builder: (context, state) {
                        if (state is MyBookingsLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state is MyBookingsFailure) {
                          return Center(child: Text(state.message));
                        }

                        if (state is MyBookingsSuccess) {
                          final upcoming = state.bookings
                              .where(
                                (b) => b.status.toLowerCase() == 'upcoming',
                              )
                              .toList();
                          final completed = state.bookings
                              .where(
                                (b) => b.status.toLowerCase() == 'completed',
                              )
                              .toList();
                          final cancelled = state.bookings
                              .where(
                                (b) => b.status.toLowerCase() == 'cancelled',
                              )
                              .toList();

                          return BlocConsumer<MyBookingsCubit, MyBookingsState>(
                            listener: (context, state) {
                              if (state is MyBookingsActionSuccess) {
                                _showTopSuccessBanner(context, state.message);
                              }
                            },
                            builder: (context, state) {
                              return TabBarView(
                                controller: _tabController,
                                children: [
                                  _buildAppointmentsList(
                                    context,
                                    appointments: upcoming,
                                    emptyMessage: 'No upcoming appointments',
                                  ),
                                  _buildAppointmentsList(
                                    context,
                                    appointments: completed,
                                    emptyMessage: 'No completed appointments',
                                  ),
                                  _buildAppointmentsList(
                                    context,
                                    appointments: cancelled,
                                    emptyMessage: 'No cancelled appointments',
                                  ),
                                ],
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppointmentsList(
    BuildContext context, {
    required List<BookingModel> appointments,
    required String emptyMessage,
  }) {
    if (appointments.isEmpty) {
      return Center(child: Text(emptyMessage, style: AppStyles.secondary12400));
    }

    return RefreshIndicator(
      onRefresh: () => context.read<MyBookingsCubit>().fetchBookings(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(AppSizes.w16),
        child: Column(
          children: [
            ...appointments.map(
              (appointment) => Padding(
                padding: EdgeInsets.only(bottom: AppSizes.h12),
                child: AppointmentCard(
                  appointment: appointment,
                  onSecondaryActionPressed: () {
                    _handleSecondaryAction(context, appointment);
                  },
                  onPrimaryActionPressed: () {
                    _handlePrimaryAction(context, appointment);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSecondaryAction(BuildContext context, BookingModel appointment) {
    if (appointment.status.toLowerCase() == 'upcoming') {
      context.push(
        AppRouter.patientCancelBookingScreen,
        extra: {
          'booking': appointment,
          'cubit': context.read<MyBookingsCubit>(),
        },
      );
      return;
    }

    if (appointment.status.toLowerCase() == 'completed') {
      context.push(AppRouter.doctorProfileScreen, extra: appointment.doctor);
      return;
    }
  }

  void _handlePrimaryAction(BuildContext context, BookingModel appointment) {
    if (appointment.status.toLowerCase() == 'upcoming') {
      showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return RescheduleAppointmentDialog(
            doctorName:
                'Dr. ${appointment.doctor.user.firstName} ${appointment.doctor.user.lastName}',
            doctorId: appointment.doctor.id,
            cubit: context.read<MyBookingsCubit>(),
            onReschedule: (newDate, newTime) {
              context.read<MyBookingsCubit>().rescheduleBooking(
                bookingId: appointment.id,
                date: newDate.toIso8601String(),
                time: newTime,
                doctorName:
                    '${appointment.doctor.user.firstName} ${appointment.doctor.user.lastName}',
              );
            },
          );
        },
      );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
          return AddReviewDialog(onRate: (rating) async {
            final doctorId = appointment.doctor.id;

            // Delegate submission to the ReviewCubit.
            context.read<ReviewCubit>().submitReview(
                  doctorId,
                  rating,
                );
          });
        },
    );
  }

  void _showTopSuccessBanner(BuildContext context, String message) {
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
}
