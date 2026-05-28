import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/home/presentation/cubit/appointments_cubit.dart';
import 'package:medi/features/doctor/features/home/presentation/cubit/appointments_state.dart';
import 'package:medi/features/doctor/features/home/presentation/widgets/doctor_appointments_states.dart';
import 'package:medi/features/doctor/features/home/presentation/widgets/doctor_appointments_table.dart';

class DoctorAppointmentsSection extends StatelessWidget {
  const DoctorAppointmentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentsCubit, AppointmentsState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          !listEquals(previous.appointments, current.appointments) ||
          previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Appointments',
                  style: AppStyles.black24700.copyWith(fontSize: AppSizes.sp20),
                ),
                const Spacer(),
                Text(
                  '${state.appointments.length} Patients',
                  style: AppStyles.secondary12400,
                ),
              ],
            ),
            SizedBox(height: AppSizes.h12),
            // If we have cached appointments, always show them (even while loading/refreshing or when remote fails).
            if (state.appointments.isNotEmpty)
              DoctorAppointmentsTable(appointments: state.appointments)
            else if (state.status == AppointmentsStatus.failure)
              DoctorAppointmentsErrorState(
                message: state.errorMessage ?? 'Something went wrong',
                onRetry: () => context.read<AppointmentsCubit>().retry(),
              )
            else if (state.status == AppointmentsStatus.loading)
              const DoctorAppointmentsLoadingState()
            else
              const DoctorAppointmentsEmptyState(),
          ],
        );
      },
    );
  }
}
