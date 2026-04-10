import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/doctors/data/models/doctor_summary.dart';

class BookAppointmentPlaceholderScreen extends StatelessWidget {
  const BookAppointmentPlaceholderScreen({
    super.key,
    required this.doctor,
  });

  final DoctorSummary? doctor;

  @override
  Widget build(BuildContext context) {
    final String doctorName = doctor?.name.replaceAll('\n', ' ') ?? 'Doctor';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSizes.w16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking flow placeholder',
              style: AppStyles.black24700,
            ),
            SizedBox(height: AppSizes.h12),
            Text(
              'Selected doctor: $doctorName',
              style: AppStyles.black16400,
            ),
          ],
        ),
      ),
    );
  }
}
