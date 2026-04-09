import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/controller/q_flow/q_flow_cubit.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/screens/q1_set_appointment_time_screen.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/screens/q2_set_appointment_type_screen.dart';

class QFlow extends StatelessWidget {
  const QFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QFlowCubit, QFlowState>(
      builder: (context, state) {
        switch (state.step) {
          case 0:
            return const Q1SetAppointmentTimeScreen();
          case 1:
            return const Q2SetAppointmentTypeScreen();
          default:
            return const SizedBox();
        }
      },
    );
  }
}
