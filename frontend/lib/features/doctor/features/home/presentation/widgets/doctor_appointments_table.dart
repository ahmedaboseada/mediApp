import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/home/data/models/doctor_appointment_model.dart';

class DoctorAppointmentsTable extends StatelessWidget {
  const DoctorAppointmentsTable({
    super.key,
    required this.appointments,
  });

  final List<DoctorAppointmentModel> appointments;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(AppSizes.r32),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          const DoctorAppointmentsHeaderRow(),
          ...appointments.map(
            (appointment) => DoctorAppointmentsDataRow(appointment: appointment),
          ),
        ],
      ),
    );
  }
}

class DoctorAppointmentsHeaderRow extends StatelessWidget {
  const DoctorAppointmentsHeaderRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w12,
        vertical: AppSizes.h10,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSizes.r32),
          topRight: Radius.circular(AppSizes.r32),
        ),
      ),
      child: Row(
        children: [
          Expanded(flex: 5, child: Text('Name', style: AppStyles.black14500)),
          Expanded(
            flex: 4,
            child: Text('Visit Time', style: AppStyles.black14500),
          ),
          Expanded(flex: 4, child: Text('Actions', style: AppStyles.black14500)),
        ],
      ),
    );
  }
}

class DoctorAppointmentsDataRow extends StatelessWidget {
  const DoctorAppointmentsDataRow({super.key, required this.appointment});

  final DoctorAppointmentModel appointment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w12,
        vertical: AppSizes.h10,
      ),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.borderColor)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Row(
              children: [
                CircleAvatar(
                  radius: AppSizes.r12,
                  backgroundImage: AssetImage(appointment.avatarAsset),
                ),
                SizedBox(width: AppSizes.w8),
                Expanded(
                  child: Text(
                    appointment.name,
                    style: AppStyles.black14400,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(appointment.visitTime, style: AppStyles.black14400),
          ),
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _actionIcon(
                  icon: Icons.play_arrow_outlined,
                  bgColor: const Color(0xFFD7E8FF),
                  iconColor: AppColors.primary,
                ),
                SizedBox(width: AppSizes.w8),
                _actionIcon(
                  icon: Icons.visibility_outlined,
                  bgColor: const Color(0xFFD7F7DD),
                  iconColor: const Color(0xFF22C55E),
                ),
                SizedBox(width: AppSizes.w8),
                _actionIcon(
                  icon: Icons.close_rounded,
                  bgColor: const Color(0xFFFBD6DC),
                  iconColor: const Color(0xFFEF4444),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionIcon({
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Container(
      width: AppSizes.w24,
      height: AppSizes.h24,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: AppSizes.h18, color: iconColor),
    );
  }
}
