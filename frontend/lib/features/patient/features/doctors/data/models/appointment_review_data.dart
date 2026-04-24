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

  final DoctorModel? doctor;
  final String dateAndHour;
  final String packageName;
  final String duration;
  final String bookingFor;
  final double amount;
  final double unitPrice;
  final String paymentMethod;
  final String location;

  AppointmentReviewData copyWith({
    DoctorModel? doctor,
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
