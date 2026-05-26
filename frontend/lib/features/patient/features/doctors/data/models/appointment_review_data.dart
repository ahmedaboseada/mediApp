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
    this.patientAge = 0,
    this.patientGender = '',
    this.problem = '',
  });

  final Doctordata? doctor;
  final String dateAndHour;
  final String packageName;
  final String duration;
  final String bookingFor;
  final double amount;
  final double unitPrice;
  final String paymentMethod;
  final String location;
  final int patientAge;
  final String patientGender;
  final String problem;

  AppointmentReviewData copyWith({
    Doctordata? doctor,
    String? dateAndHour,
    String? packageName,
    String? duration,
    String? bookingFor,
    double? amount,
    double? unitPrice,
    String? paymentMethod,
    String? location,
    int? patientAge,
    String? patientGender,
    String? problem,
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
      patientAge: patientAge ?? this.patientAge,
      patientGender: patientGender ?? this.patientGender,
      problem: problem ?? this.problem,
    );
  }
}
