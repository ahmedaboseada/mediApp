import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/patients/data/models/booking_session_model.dart';
import 'package:medi/features/doctor/features/patients/data/models/patient_data.dart';
import 'package:medi/features/doctor/features/patients/presentation/cubit/booking_session/booking_session_cubit.dart';
import 'package:medi/features/doctor/features/patients/presentation/cubit/manage_meds/mange_meds_cubit.dart';
import 'package:medi/features/doctor/features/patients/presentation/widgets/add_patient_medication_dialog.dart';
import 'package:medi/features/doctor/features/patients/presentation/widgets/patient_health_reports_tab.dart';
import 'package:medi/features/doctor/features/patients/presentation/widgets/patient_medications_tab.dart';
import 'package:medi/features/doctor/features/patients/presentation/widgets/patient_overview_tab.dart';
import 'package:medi/features/doctor/features/patients/presentation/widgets/patient_profile_header.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({
    super.key,
    required this.patient,
    this.showAddMedicationAction = false,
    this.bookingSession,
    this.bookingSessionCubit,
  });

  final PatientData patient;
  final bool showAddMedicationAction;
  final BookingSessionModel? bookingSession;
  final BookingSessionCubit? bookingSessionCubit;

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  int _selectedTabIndex = 0;
  Timer? _sessionTimer;
  Duration _remainingSessionTime = Duration.zero;
  bool _isEndingSession = false;

  @override
  void initState() {
    super.initState();
    _startSessionTimer();
  }

  @override
  void didUpdateWidget(covariant PatientProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bookingSession?.expiresAt !=
        widget.bookingSession?.expiresAt) {
      _startSessionTimer();
    }
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    widget.bookingSessionCubit?.close();
    super.dispose();
  }

  void _startSessionTimer() {
    _sessionTimer?.cancel();

    final session = widget.bookingSession;
    if (session == null) {
      return;
    }

    final expiresAt = DateTime.tryParse(session.expiresAt);
    if (expiresAt == null) {
      return;
    }

    void updateRemainingTime() {
      final remaining = expiresAt.difference(DateTime.now());
      if (!mounted) {
        return;
      }

      setState(() {
        _remainingSessionTime = remaining.isNegative
            ? Duration.zero
            : remaining;
      });

      if (remaining.isNegative || remaining.inSeconds <= 0) {
        _sessionTimer?.cancel();
      }
    }

    updateRemainingTime();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      updateRemainingTime();
    });
  }

  Future<void> _endSession() async {
    final session = widget.bookingSession;
    final sessionCubit = widget.bookingSessionCubit;

    if (session == null || sessionCubit == null || _isEndingSession) {
      return;
    }

    setState(() {
      _isEndingSession = true;
    });

    final result = await sessionCubit.endSession(session.bookingId);

    if (!mounted) {
      return;
    }

    result.fold(
      (failure) {
        setState(() {
          _isEndingSession = false;
        });

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(failure.message)));
      },
      (_) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('Session ended successfully')),
          );

        Navigator.of(context).pop();
      },
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    final parts = <String>[];

    if (hours > 0) {
      parts.add(hours.toString().padLeft(2, '0'));
    }
    parts.add(minutes.toString().padLeft(2, '0'));
    parts.add(seconds.toString().padLeft(2, '0'));

    return parts.join(':');
  }

  Widget _buildSessionPanel() {
    final session = widget.bookingSession;
    if (session == null) {
      return const SizedBox.shrink();
    }

    final isExpired = _remainingSessionTime == Duration.zero;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.w16),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.primary.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Active session', style: AppStyles.black18500),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.w10,
                  vertical: AppSizes.h6,
                ),
                decoration: BoxDecoration(
                  color: isExpired
                      ? const Color(0xFFFFE8E8)
                      : const Color(0xFFE8F6FF),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  isExpired ? 'Expired' : 'Live',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: isExpired
                        ? const Color(0xFFD32F2F)
                        : const Color(0xFF0B6FA4),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.h10),
          Text(
            'Booking ID: ${session.bookingId}',
            style: AppStyles.secondary12400,
          ),
          SizedBox(height: AppSizes.h6),
          Text(
            isExpired
                ? 'Session timer expired'
                : 'Time remaining: ${_formatDuration(_remainingSessionTime)}',
            style: AppStyles.black14500,
          ),
          SizedBox(height: AppSizes.h12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: (isExpired || _isEndingSession) ? null : _endSession,
              icon: _isEndingSession
                  ? SizedBox(
                      height: 16.sp,
                      width: 16.sp,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.stop_circle_outlined),
              label: Text(
                _isEndingSession ? 'Ending session...' : 'End session',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openAddMedicationDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider<ManageMedsCubit>(
        create: (_) => getIt<ManageMedsCubit>(),
        child: AddPatientMedicationDialog(
          patientName: widget.patient.name,
          patientId: widget.patient.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppSizes.w16,
                  AppSizes.h12,
                  AppSizes.w16,
                  AppSizes.h16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PatientProfileHeader(
                      patient: widget.patient,
                      selectedTabIndex: _selectedTabIndex,
                      onTabChanged: (index) {
                        setState(() {
                          _selectedTabIndex = index;
                        });
                      },
                    ),
                    if (widget.bookingSession != null) ...[
                      SizedBox(height: AppSizes.h16),
                      _buildSessionPanel(),
                    ],
                    SizedBox(height: AppSizes.h20),
                    if (_selectedTabIndex == 0) ...[
                      PatientOverviewTab(patient: widget.patient),
                    ],
                    if (_selectedTabIndex == 1) ...[
                      PatientMedicationsTab(
                        onEditMedication: _openAddMedicationDialog,
                        patient: widget.patient,
                        showAddMedicationAction: widget.showAddMedicationAction,
                        onAddMedication: _openAddMedicationDialog,
                      ),
                    ],
                    if (_selectedTabIndex == 2) ...[
                      PatientHealthReportsTab(patient: widget.patient),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(height: AppSizes.h64),
          ],
        ),
      ),
    );
  }
}
