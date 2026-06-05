
import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/home/data/models/doctor_appointment_model.dart';
import 'package:medi/features/doctor/features/patients/presentation/screens/patient_profile_screen.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit/zego_uikit.dart';

class DoctorAppointmentsTable extends StatelessWidget {
  const DoctorAppointmentsTable({super.key, required this.appointments});

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
            (appointment) =>
                DoctorAppointmentsDataRow(appointment: appointment),
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
          Expanded(
            flex: 4,
            child: Text('Actions', style: AppStyles.black14500),
          ),
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
                    appointment.bookingFor.toLowerCase() == 'self'
                        ? (appointment.patientName ?? appointment.name)
                        : (appointment.reserverName ?? appointment.name),
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
               
                 
                    ZegoSendCallInvitationButton(
                      isVideoCall: true,
                      buttonSize: const Size(40, 40),
                        //buttonSize: Size(AppSizes.w24, AppSizes.h24),
                          iconSize: const Size(24, 24),
                          clickableBackgroundColor: const Color(0xFFD7E8FF),
                          

                        icon:ButtonIcon(icon: Icon(Icons.play_arrow_outlined),),
                      //You need to use the resourceID that you created in the subsequent steps.
                      //Please continue reading this document.
                      resourceID: "medi_call",
                      invitees: [
                        ZegoUIKitUser(
                          id: appointment.userId ?? appointment.name,
                          
                          name: appointment.patientName ?? appointment.name,
                        )
                      ],
                    ),
                  
                
                // _actionIcon(
                //   icon: Icons.play_arrow_outlined,
                //   bgColor: const Color(0xFFD7E8FF),
                //   iconColor: AppColors.primary,
                //   onTap: () {
                //     // Handle play arrow icon tap
                //   },
                // ),
                 SizedBox(width: AppSizes.w8),
               if (appointment.bookingFor.toLowerCase() == 'self') 
                _actionIcon(
                  icon: Icons.visibility_outlined,
                  bgColor: const Color(0xFFD7F7DD),
                  iconColor: const Color(0xFF22C55E),
                  onTap: () {
                    if (appointment.patientData != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PatientProfileScreen(
                            patient: appointment.patientData!,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Patient data not available')),
                      );
                    }
                  },
                ),
                // SizedBox(width: AppSizes.w8),
                // _actionIcon(
                //   icon: Icons.close_rounded,
                //   bgColor: const Color(0xFFFBD6DC),
                //   iconColor: const Color(0xFFEF4444),
                // ),
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
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSizes.w40,
        height: AppSizes.h40,
        decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
        child: Icon(icon, size: AppSizes.h24, color: iconColor),
      ),
    );
  }
}
