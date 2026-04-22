import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/doctors/data/models/doctor_summary.dart';

class AppointmentReviewData {
  const AppointmentReviewData({
    required this.doctor,
    required this.dateAndHour,
    required this.packageName,
    required this.duration,
    required this.bookingFor,
    required this.amount,
    required this.unitPrice,
    required this.paymentMethod,
    required this.location,
  });

  final DoctorSummary doctor;
  final String dateAndHour;
  final String packageName;
  final String duration;
  final String bookingFor;
  final double amount;
  final double unitPrice;
  final String paymentMethod;
  final String location;

  factory AppointmentReviewData.fallback() {
    return const AppointmentReviewData(
      doctor: DoctorSummary(
        id: 'dr_marvin_kinney',
        name: 'Dr. Marvin Kinney',
        specialty: 'Cardiologist',
        rating: 4.8,
        reviewsCount: 82,
        imageAsset: AppAssets.avatar1,
      ),
      dateAndHour: 'August 24, 2023 | 10:00 AM',
      packageName: 'Online',
      duration: '30 minutes',
      bookingFor: 'Self',
      amount: 60,
      unitPrice: 20,
      paymentMethod: 'Cash',
      location: 'New York, United Stats',
    );
  }

  AppointmentReviewData copyWith({
    DoctorSummary? doctor,
    String? dateAndHour,
    String? packageName,
    String? duration,
    String? bookingFor,
    double? amount,
    double? unitPrice,
    String? paymentMethod,
    String? location,
  }) {
    return AppointmentReviewData(
      doctor: doctor ?? this.doctor,
      dateAndHour: dateAndHour ?? this.dateAndHour,
      packageName: packageName ?? this.packageName,
      duration: duration ?? this.duration,
      bookingFor: bookingFor ?? this.bookingFor,
      amount: amount ?? this.amount,
      unitPrice: unitPrice ?? this.unitPrice,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      location: location ?? this.location,
    );
  }
}
